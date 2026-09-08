import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';

typedef SyncHandler =
    Future<void> Function(OutboxEntry entry, Map<String, dynamic> payload);

/// Drift-backed outbox with read-before-retry reconciliation.
class SyncOutboxService extends GetxService {
  SyncOutboxService(this._db, this._api);

  final AppDatabase _db;
  final ApiClient _api;
  final Map<String, SyncHandler> _handlers = {};
  final RxInt pendingCount = 0.obs;

  /// Task ids with a queued place-order / end-visit waiting to sync.
  final RxMap<int, String> pendingSyncByTaskId = <int, String>{}.obs;

  bool _flushing = false;
  static const _maxAttempts = 3;
  static const _uuid = Uuid();

  Future<SyncOutboxService> init() async {
    await refreshPendingCount();
    _registerObHandlers();
    return this;
  }

  void registerHandler(String role, String action, SyncHandler handler) {
    _handlers['$role.$action'] = handler;
  }

  bool isTaskQueuedForSync(int taskId) =>
      pendingSyncByTaskId.containsKey(taskId);

  String? queuedActionForTask(int taskId) => pendingSyncByTaskId[taskId];

  Future<void> refreshPendingCount() async {
    pendingCount.value = await _db.pendingOutboxCount();
    await _refreshPendingSyncByTask();
  }

  Future<void> _refreshPendingSyncByTask() async {
    final pending = await _db.pendingOutbox();
    final map = <int, String>{};
    for (final entry in pending) {
      if (entry.role != 'orderBooker') continue;
      if (entry.action != 'submit_order' &&
          entry.action != 'end_visit_without_order') {
        continue;
      }
      try {
        final payload = Map<String, dynamic>.from(
          jsonDecode(entry.payloadJson) as Map,
        );
        final taskId = ApiMap.asInt(payload['task_id']);
        if (taskId != null) {
          map[taskId] = entry.action;
        }
      } catch (_) {
        // Ignore malformed payloads for UI overlay.
      }
    }
    pendingSyncByTaskId
      ..clear()
      ..addAll(map);
  }

  Future<OutboxEntry> enqueue({
    required String role,
    required String action,
    required Map<String, dynamic> payload,
    String? clientRequestId,
  }) async {
    final id = 'sync-${DateTime.now().millisecondsSinceEpoch}-${_uuid.v4()}';
    final entry = OutboxEntriesCompanion.insert(
      id: id,
      role: role,
      action: action,
      payloadJson: jsonEncode(payload),
      clientRequestId: clientRequestId ?? _uuid.v4(),
      status: const Value('queued'),
      createdAt: DateTime.now(),
    );
    await _db.into(_db.outboxEntries).insert(entry);
    await refreshPendingCount();
    return (await (_db.select(
      _db.outboxEntries,
    )..where((t) => t.id.equals(id))).getSingle());
  }

  Future<void> flush({bool force = false}) async {
    if (_flushing) return;
    if (!force && Get.isRegistered<ConnectivityService>()) {
      final connectivity = Get.find<ConnectivityService>();
      if (!connectivity.isOnline.value) return;
    }

    _flushing = true;
    try {
      final pending = await _db.pendingOutbox();
      for (final entry in pending) {
        final handler = _handlers['${entry.role}.${entry.action}'];
        if (handler == null) {
          await _mark(
            entry,
            status: 'failed',
            error: 'No sync handler registered',
          );
          continue;
        }

        await _mark(entry, status: 'syncing');
        Map<String, dynamic> payload;
        try {
          payload = Map<String, dynamic>.from(
            jsonDecode(entry.payloadJson) as Map,
          );
        } catch (_) {
          await _mark(entry, status: 'failed', error: 'Invalid payload');
          continue;
        }

        try {
          await handler(entry, payload);
          await _mark(entry, status: 'synced', syncedAt: DateTime.now());
        } on ApiException catch (e) {
          await _handleFailure(entry, e.message);
        } catch (e) {
          await _handleFailure(entry, e.toString());
        }
      }
    } finally {
      _flushing = false;
      await refreshPendingCount();
    }
  }

  Future<void> _handleFailure(OutboxEntry entry, String message) async {
    final attempts = entry.attempts + 1;
    final status = attempts >= _maxAttempts ? 'needsReview' : 'failed';
    await (_db.update(
      _db.outboxEntries,
    )..where((t) => t.id.equals(entry.id))).write(
      OutboxEntriesCompanion(
        status: Value(status),
        attempts: Value(attempts),
        lastError: Value(message),
      ),
    );
  }

  Future<void> _mark(
    OutboxEntry entry, {
    required String status,
    String? error,
    DateTime? syncedAt,
  }) async {
    await (_db.update(
      _db.outboxEntries,
    )..where((t) => t.id.equals(entry.id))).write(
      OutboxEntriesCompanion(
        status: Value(status),
        lastError: error == null ? const Value.absent() : Value(error),
        syncedAt: syncedAt == null ? const Value.absent() : Value(syncedAt),
      ),
    );
  }

  Future<List<OutboxEntry>> listPending() => _db.pendingOutbox();

  Future<void> clearSessionData() async {
    await _db.clearOutbox();
    await _db.clearVisitLocalData();
    pendingSyncByTaskId.clear();
    await refreshPendingCount();
  }

  Future<void> retryEntry(String id) async {
    await (_db.update(_db.outboxEntries)..where((t) => t.id.equals(id))).write(
      const OutboxEntriesCompanion(
        status: Value('queued'),
        lastError: Value(null),
      ),
    );
    await flush(force: true);
  }

  void _registerObHandlers() {
    registerHandler('orderBooker', 'submit_order', _handleObSubmitOrder);
    registerHandler(
      'orderBooker',
      'end_visit_without_order',
      _handleObEndWithoutOrder,
    );
    registerHandler('orderBooker', 'visit_notes', _handleObVisitNotes);
    registerHandler('orderBooker', 'task_notes', _handleObTaskNotes);
  }

  Future<void> _handleObSubmitOrder(
    OutboxEntry entry,
    Map<String, dynamic> payload,
  ) async {
    final visitId = ApiMap.asInt(payload['visit_id']);
    if (visitId == null) throw ApiException(message: 'Missing visit_id');

    if (await _visitHasOrder(visitId)) return;

    final lines = _linesFromPayload(payload['lines']);
    await _syncCartToServer(visitId: visitId, lines: lines);

    final lat = ApiMap.asDouble(payload['latitude']);
    final lng = ApiMap.asDouble(payload['longitude']);
    if (lat == null || lng == null) {
      throw ApiException(message: 'Missing GPS for order submit');
    }

    try {
      await _api.postData(
        ApiEndpoints.obVisitsPlaceOrder,
        data: {'visit_id': visitId, 'latitude': lat, 'longitude': lng},
      );
    } on ApiException {
      if (await _visitHasOrder(visitId)) return;
      rethrow;
    }

    if (!await _visitHasOrder(visitId)) {
      throw ApiException(message: 'Order submit did not produce an order');
    }
  }

  Future<void> _handleObEndWithoutOrder(
    OutboxEntry entry,
    Map<String, dynamic> payload,
  ) async {
    final visitId = ApiMap.asInt(payload['visit_id']);
    if (visitId == null) throw ApiException(message: 'Missing visit_id');

    if (await _visitAlreadyClosed(visitId)) return;

    try {
      await _api.postData(
        ApiEndpoints.obVisitsEndWithoutOrder,
        data: {
          'visit_id': visitId,
          'notes': ApiMap.asString(payload['notes']) ?? '',
        },
      );
    } on ApiException {
      if (await _visitAlreadyClosed(visitId)) return;
      rethrow;
    }
  }

  Future<void> _handleObVisitNotes(
    OutboxEntry entry,
    Map<String, dynamic> payload,
  ) async {
    final visitId = ApiMap.asInt(payload['visit_id']);
    if (visitId == null) throw ApiException(message: 'Missing visit_id');
    await _api.postData(
      ApiEndpoints.obVisitsNotes,
      data: {
        'visit_id': visitId,
        'notes': ApiMap.asString(payload['notes']) ?? '',
      },
    );
  }

  Future<void> _handleObTaskNotes(
    OutboxEntry entry,
    Map<String, dynamic> payload,
  ) async {
    final taskId = ApiMap.asInt(payload['task_id']);
    if (taskId == null) throw ApiException(message: 'Missing task_id');
    await _api.postData(
      ApiEndpoints.obTasksNotes,
      data: {
        'task_id': taskId,
        'notes': ApiMap.asString(payload['notes']) ?? '',
      },
    );
  }

  Future<bool> _visitHasOrder(int visitId) async {
    final data = await _api.postData(
      ApiEndpoints.obVisitsGet,
      data: {'visit_id': visitId},
    );
    final visit = ApiMap.asMap(data['visit']) ?? data;
    final orderNumber =
        ApiMap.asString(visit['sale_order_name']) ??
        ApiMap.asString(visit['order_number']);
    return orderNumber != null && orderNumber.isNotEmpty;
  }

  Future<bool> _visitAlreadyClosed(int visitId) async {
    try {
      final data = await _api.postData(
        ApiEndpoints.obVisitsGet,
        data: {'visit_id': visitId},
      );
      final visit = ApiMap.asMap(data['visit']) ?? data;
      final state = ApiMap.asString(visit['state'])?.toLowerCase();
      final outcome = ApiMap.asString(visit['outcome'])?.toLowerCase();
      return state == 'completed' ||
          state == 'closed' ||
          outcome == 'order_placed' ||
          outcome == 'ended_without_order';
    } catch (_) {
      return false;
    }
  }

  Future<void> _syncCartToServer({
    required int visitId,
    required List<Map<String, dynamic>> lines,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.obVisitsGet,
      data: {'visit_id': visitId},
    );
    final visit = ApiMap.asMap(data['visit']) ?? data;
    final serverLines = ApiMap.listOf(visit, 'lines');

    final serverByProduct = <int, Map<String, dynamic>>{};
    for (final line in serverLines) {
      final pid = ApiMap.asInt(line['product_id']);
      if (pid != null) serverByProduct[pid] = line;
    }

    final localByProduct = <int, Map<String, dynamic>>{};
    for (final line in lines) {
      final pid = ApiMap.asInt(line['product_id']);
      if (pid != null) localByProduct[pid] = line;
    }

    for (final entry in serverByProduct.entries) {
      if (!localByProduct.containsKey(entry.key)) {
        final lineId =
            ApiMap.asInt(entry.value['line_id']) ??
            ApiMap.asInt(entry.value['id']);
        if (lineId != null) {
          await _api.postData(
            ApiEndpoints.obVisitsLineRemove,
            data: {'line_id': lineId},
          );
        }
      }
    }

    for (final entry in localByProduct.entries) {
      final productId = entry.key;
      final local = entry.value;
      final qty = ApiMap.asDouble(local['quantity']) ?? 0;
      final price = ApiMap.asDouble(local['price_unit']) ?? 0;
      final server = serverByProduct[productId];

      if (server == null) {
        await _api.postData(
          ApiEndpoints.obVisitsLineAdd,
          data: {'visit_id': visitId, 'product_id': productId, 'quantity': qty},
        );
        continue;
      }

      final lineId =
          ApiMap.asInt(server['line_id']) ?? ApiMap.asInt(server['id']);
      if (lineId == null) continue;

      final serverQty = ApiMap.asDouble(server['quantity']) ?? 0;
      final serverPrice = ApiMap.asDouble(server['price_unit']) ?? 0;
      if ((serverQty - qty).abs() > 0.001 ||
          (serverPrice - price).abs() > 0.001) {
        await _api.postData(
          ApiEndpoints.obVisitsLineUpdate,
          data: {
            'line_id': lineId,
            'quantity': qty,
            if ((serverPrice - price).abs() > 0.001) 'price_unit': price,
          },
        );
      }
    }
  }

  List<Map<String, dynamic>> _linesFromPayload(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
  }
}
