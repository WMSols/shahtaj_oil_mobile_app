import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/local_media_store.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/sync/outbox_payload.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_check_in_result.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/sync/ob_day_bootstrap_service.dart';

typedef SyncHandler =
    Future<void> Function(OutboxEntry entry, Map<String, dynamic> payload);

/// Outbox statuses.
///
/// * `queued` — waiting for a flush.
/// * `syncing` — in flight.
/// * `synced` — accepted by the server.
/// * `failed` — transient problem, retried on the next flush.
/// * `blocked` — waiting on [OutboxEntry.dependsOn] or an unmapped local id.
/// * `needsReview` — the server rejected it; a human has to look.
abstract class OutboxStatus {
  static const queued = 'queued';
  static const syncing = 'syncing';
  static const synced = 'synced';
  static const failed = 'failed';
  static const blocked = 'blocked';
  static const needsReview = 'needsReview';
}

/// Drift-backed outbox with dependency ordering, local id remapping and
/// read-before-write reconciliation so a retry never duplicates server data.
class SyncOutboxService extends GetxService {
  SyncOutboxService(this._db, this._api, this._media);

  final AppDatabase _db;
  final ApiClient _api;
  final LocalMediaStore _media;
  final Map<String, SyncHandler> _handlers = {};
  final RxInt pendingCount = 0.obs;

  /// Task ids with a queued place-order / end-visit waiting to sync.
  final RxMap<int, String> pendingSyncByTaskId = <int, String>{}.obs;

  /// Closing actions that need a manual retry.
  final RxMap<int, String> needsReviewByTaskId = <int, String>{}.obs;

  /// Every queued OB action per task id (check-in, verify, notes, order...).
  final RxMap<int, List<String>> queuedActionsByTaskId =
      <int, List<String>>{}.obs;

  /// Queued work that belongs to a different signed-in user.
  final RxInt otherUserPendingCount = 0.obs;

  /// True while [flush] is walking the outbox.
  final RxBool isFlushing = false.obs;

  /// Owned entries in `failed` or `needsReview` (banner / Sync Center).
  final RxInt attentionCount = 0.obs;

  /// Most recent local → server visit id swap (Create Order listens to refresh).
  final Rxn<VisitIdRemap> lastVisitRemap = Rxn<VisitIdRemap>();

  /// Bumped after every flush finishes so Today / active visit can reload.
  final Rxn<DateTime> lastFlushAt = Rxn<DateTime>();

  static const _maxAttempts = 3;
  static const _uuid = Uuid();

  /// Telemetry-only outbox rows (distributor panel). Hidden from Sync Center
  /// and cleared after flush — the OB cannot usefully retry them.
  static bool isSilentTelemetryAction(String action) => action == 'gps_attempt';

  Future<SyncOutboxService> init() async {
    _registerObHandlers();
    await refreshPendingCount();
    return this;
  }

  void registerHandler(String role, String action, SyncHandler handler) {
    _handlers['$role.$action'] = handler;
  }

  bool isTaskQueuedForSync(int taskId) =>
      pendingSyncByTaskId.containsKey(taskId);

  bool isTaskNeedsReview(int taskId) => needsReviewByTaskId.containsKey(taskId);

  String? queuedActionForTask(int taskId) => pendingSyncByTaskId[taskId];

  bool hasQueuedWorkForTask(int taskId) =>
      (queuedActionsByTaskId[taskId] ?? const []).isNotEmpty;

  String? get _currentUserId {
    if (!Get.isRegistered<SessionService>()) return null;
    final id = Get.find<SessionService>().user.value?.id;
    return (id == null || id.isEmpty) ? null : id;
  }

  /// Legacy null-owner rows are claimed on login; until then they must not
  /// flush or badge under a different booker.
  bool _isOwnedByCurrentUser(OutboxEntry entry) {
    final owner = entry.userId;
    if (owner == null || owner.isEmpty) return false;
    final current = _currentUserId;
    if (current == null) return false;
    return owner == current;
  }

  /// Counts only the signed-in user's work, so the badge and the logout
  /// prompt never talk about another booker's queue.
  Future<void> refreshPendingCount() async {
    final open = await _db.openOutbox();
    final submits = <int, String>{};
    final reviews = <int, String>{};
    final actions = <int, List<String>>{};
    var otherUser = 0;
    var own = 0;
    var attention = 0;

    for (final entry in open) {
      // Far-GPS pings sync in the background but never surface to the OB.
      if (isSilentTelemetryAction(entry.action)) continue;

      if (!_isOwnedByCurrentUser(entry)) {
        otherUser++;
        continue;
      }
      own++;
      if (entry.status == OutboxStatus.failed ||
          entry.status == OutboxStatus.needsReview) {
        attention++;
      }
      if (entry.role != 'orderBooker') continue;

      int? taskId;
      try {
        final payload = Map<String, dynamic>.from(
          jsonDecode(entry.payloadJson) as Map,
        );
        taskId = ApiMap.asInt(payload['task_id']);
      } catch (_) {
        continue;
      }
      if (taskId == null) continue;

      (actions[taskId] ??= <String>[]).add(entry.action);
      if (entry.action == 'submit_order' ||
          entry.action == 'end_visit_without_order') {
        submits[taskId] = entry.action;
        if (entry.status == OutboxStatus.needsReview ||
            entry.status == OutboxStatus.failed) {
          reviews[taskId] = entry.action;
        }
      }
    }

    pendingSyncByTaskId
      ..clear()
      ..addAll(submits);
    needsReviewByTaskId
      ..clear()
      ..addAll(reviews);
    queuedActionsByTaskId
      ..clear()
      ..addAll(actions);
    otherUserPendingCount.value = otherUser;
    pendingCount.value = own;
    attentionCount.value = attention;
  }

  Future<OutboxEntry> enqueue({
    required String role,
    required String action,
    required Map<String, dynamic> payload,
    String? clientRequestId,
    String? dependsOn,
    String? entityType,
    int? localEntityId,
  }) async {
    final requestId = clientRequestId ?? _uuid.v4();
    if (action == 'gps_attempt') {
      final existing = await _db.outboxByClientRequestId(requestId);
      if (existing != null &&
          existing.status != OutboxStatus.synced &&
          existing.status != OutboxStatus.needsReview) {
        return existing;
      }
    }

    final id = 'sync-${DateTime.now().millisecondsSinceEpoch}-${_uuid.v4()}';
    final mediaIds = OutboxPayload.collectMediaIds(payload);
    final entry = OutboxEntriesCompanion.insert(
      id: id,
      role: role,
      action: action,
      payloadJson: jsonEncode(payload),
      clientRequestId: requestId,
      status: const Value(OutboxStatus.queued),
      createdAt: DateTime.now(),
      dependsOn: Value(dependsOn),
      userId: Value(_currentUserId),
      entityType: Value(entityType),
      localEntityId: Value(localEntityId),
      mediaIds: Value(mediaIds.isEmpty ? null : mediaIds.join(',')),
    );
    await _db.into(_db.outboxEntries).insert(entry);
    await refreshPendingCount();
    return (await (_db.select(
      _db.outboxEntries,
    )..where((t) => t.id.equals(id))).getSingle());
  }

  /// True when a blocked GPS telemetry row with this id is already queued.
  Future<bool> hasPendingGpsAttempt({required String clientRequestId}) async {
    final existing = await _db.outboxByClientRequestId(clientRequestId);
    if (existing == null) return false;
    return existing.action == 'gps_attempt' &&
        existing.status != OutboxStatus.synced;
  }

  /// Queues [payload] and, when the link is good enough, tries it right away.
  ///
  /// Returns true when the server has accepted it, false when it stays queued.
  /// Callers use this to pick between "saved" and "will sync" wording.
  Future<bool> enqueueAndFlush({
    required String role,
    required String action,
    required Map<String, dynamic> payload,
    String? clientRequestId,
    String? dependsOn,
    String? entityType,
    int? localEntityId,
  }) async {
    final entry = await enqueue(
      role: role,
      action: action,
      payload: payload,
      clientRequestId: clientRequestId,
      dependsOn: dependsOn,
      entityType: entityType,
      localEntityId: localEntityId,
    );
    if (!_isReadyForImmediateSync) return false;
    await flush(force: true);
    final after = await _db.outboxById(entry.id);
    return after == null || after.status == OutboxStatus.synced;
  }

  bool get _isReadyForImmediateSync {
    if (!Get.isRegistered<ConnectivityService>()) return true;
    final connectivity = Get.find<ConnectivityService>();
    if (!connectivity.isOnline.value) return false;
    return connectivity.quality.value != NetworkQuality.weak;
  }

  Future<void> flush({bool force = false}) async {
    if (isFlushing.value) return;
    if (!force && Get.isRegistered<ConnectivityService>()) {
      final connectivity = Get.find<ConnectivityService>();
      if (!connectivity.isOnline.value) return;
    }

    isFlushing.value = true;
    try {
      final pending = await _db.pendingOutbox();
      // Statuses reached during this pass, so a child sees its parent's result
      // without re-reading the database.
      final resolvedStatus = <String, String>{};

      for (final entry in pending) {
        if (!_isOwnedByCurrentUser(entry)) continue;

        final handler = _handlers['${entry.role}.${entry.action}'];
        if (handler == null) {
          await _mark(
            entry,
            status: OutboxStatus.needsReview,
            error: 'No sync handler registered',
          );
          resolvedStatus[entry.id] = OutboxStatus.needsReview;
          continue;
        }

        final blockedReason = await _dependencyBlockReason(
          entry,
          resolvedStatus,
        );
        if (blockedReason != null) {
          await _mark(
            entry,
            status: OutboxStatus.blocked,
            error: blockedReason,
          );
          resolvedStatus[entry.id] = OutboxStatus.blocked;
          continue;
        }

        Map<String, dynamic> raw;
        try {
          raw = Map<String, dynamic>.from(jsonDecode(entry.payloadJson) as Map);
        } catch (_) {
          await _mark(
            entry,
            status: OutboxStatus.needsReview,
            error: 'Invalid payload',
          );
          resolvedStatus[entry.id] = OutboxStatus.needsReview;
          continue;
        }

        Map<String, dynamic> payload;
        try {
          payload = await OutboxPayload.resolve(
            raw,
            lookupServerId: _db.serverIdFor,
            readMediaBase64: _media.readBase64,
          );
        } on UnresolvedLocalIdException catch (e) {
          await _mark(entry, status: OutboxStatus.blocked, error: e.toString());
          resolvedStatus[entry.id] = OutboxStatus.blocked;
          continue;
        } on MissingMediaException catch (e) {
          await _mark(
            entry,
            status: OutboxStatus.needsReview,
            error: e.toString(),
          );
          resolvedStatus[entry.id] = OutboxStatus.needsReview;
          continue;
        }

        await _mark(entry, status: OutboxStatus.syncing);
        try {
          await handler(entry, payload);
          if (isSilentTelemetryAction(entry.action)) {
            await _db.deleteOutboxEntry(entry.id);
            resolvedStatus[entry.id] = OutboxStatus.synced;
          } else {
            await _mark(
              entry,
              status: OutboxStatus.synced,
              syncedAt: DateTime.now(),
              error: '',
            );
            await _discardMedia(entry);
            resolvedStatus[entry.id] = OutboxStatus.synced;
          }
        } on ApiException catch (e) {
          resolvedStatus[entry.id] = await _handleFailure(entry, e.message);
        } catch (e) {
          resolvedStatus[entry.id] = await _handleFailure(entry, e.toString());
        }
      }
    } finally {
      isFlushing.value = false;
      await refreshPendingCount();
      lastFlushAt.value = DateTime.now();
    }
  }

  /// Returns a reason when [entry] must wait, or null when it may run.
  Future<String?> _dependencyBlockReason(
    OutboxEntry entry,
    Map<String, String> resolvedStatus,
  ) async {
    final dependsOn = entry.dependsOn;
    if (dependsOn == null || dependsOn.isEmpty) return null;

    final status =
        resolvedStatus[dependsOn] ?? (await _db.outboxById(dependsOn))?.status;

    // Parent row is gone: its mapping either exists (id resolution proves it)
    // or the payload resolver will block this entry anyway.
    if (status == null) return null;
    if (status == OutboxStatus.synced) return null;
    if (status == OutboxStatus.needsReview) {
      return 'Waiting on an earlier step that needs review.';
    }
    return 'Waiting for an earlier step to sync.';
  }

  Future<void> _discardMedia(OutboxEntry entry) async {
    final ids = entry.mediaIds;
    if (ids == null || ids.isEmpty) return;
    await _media.discard(
      ids.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty),
    );
  }

  /// Network noise must never strand real work, so only genuine server
  /// rejections count against [_maxAttempts].
  bool _isTransient(String message) {
    final msg = message.toLowerCase();
    return msg.contains('timed out') ||
        msg.contains('timeout') ||
        msg.contains('internet') ||
        msg.contains('connection') ||
        msg.contains('socket') ||
        msg.contains('network') ||
        msg.contains('host') ||
        msg.contains('502') ||
        msg.contains('503') ||
        msg.contains('504') ||
        msg.contains('bad gateway') ||
        msg.contains('unavailable');
  }

  Future<String> _handleFailure(OutboxEntry entry, String message) async {
    // Telemetry: silent retries only; drop after the limit so Sync Center
    // never asks the OB to retry a far-GPS ping.
    if (isSilentTelemetryAction(entry.action)) {
      final transient = _isTransient(message);
      final attempts = transient ? entry.attempts : entry.attempts + 1;
      if (!transient || attempts >= _maxAttempts) {
        await _db.deleteOutboxEntry(entry.id);
        return OutboxStatus.synced;
      }
      await (_db.update(
        _db.outboxEntries,
      )..where((t) => t.id.equals(entry.id))).write(
        OutboxEntriesCompanion(
          status: const Value(OutboxStatus.failed),
          attempts: Value(attempts),
          lastError: Value(message),
        ),
      );
      return OutboxStatus.failed;
    }

    final transient = _isTransient(message);
    final attempts = transient ? entry.attempts : entry.attempts + 1;
    final status = attempts >= _maxAttempts
        ? OutboxStatus.needsReview
        : OutboxStatus.failed;
    await (_db.update(
      _db.outboxEntries,
    )..where((t) => t.id.equals(entry.id))).write(
      OutboxEntriesCompanion(
        status: Value(status),
        attempts: Value(attempts),
        lastError: Value(message),
      ),
    );
    return status;
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
        lastError: error == null
            ? const Value.absent()
            : Value(error.isEmpty ? null : error),
        syncedAt: syncedAt == null ? const Value.absent() : Value(syncedAt),
      ),
    );
  }

  Future<List<OutboxEntry>> listPending() async {
    final open = await _db.openOutbox();
    return open
        .where((e) => !isSilentTelemetryAction(e.action))
        .toList(growable: false);
  }

  /// Explicit "clear local data" only. Never called on logout.
  Future<void> clearSessionData() async {
    await _db.clearAllLocalWork();
    pendingSyncByTaskId.clear();
    needsReviewByTaskId.clear();
    queuedActionsByTaskId.clear();
    attentionCount.value = 0;
    pendingCount.value = 0;
    otherUserPendingCount.value = 0;
    await refreshPendingCount();
  }

  Future<void> retryEntry(String id) async {
    await (_db.update(_db.outboxEntries)..where((t) => t.id.equals(id))).write(
      const OutboxEntriesCompanion(
        status: Value(OutboxStatus.queued),
        lastError: Value(null),
        attempts: Value(0),
      ),
    );
    await flush(force: true);
  }

  /// Removes a Sync Center item (and its media) without wiping other local work.
  Future<void> discardEntry(String id) async {
    final entry = await _db.outboxById(id);
    if (entry == null) return;
    await _discardMedia(entry);
    await _db.deleteOutboxEntry(id);
    await refreshPendingCount();
  }

  Future<void> discardEntries(Iterable<String> ids) async {
    final entries = <OutboxEntry>[];
    for (final id in ids) {
      final entry = await _db.outboxById(id);
      if (entry != null) entries.add(entry);
    }
    for (final entry in entries) {
      await _discardMedia(entry);
      await _db.deleteOutboxEntry(entry.id);
    }
    // Rebuild badges before deciding which task overrides to clear.
    await refreshPendingCount();
    await _discardLocalVisitArtifacts(entries);
  }

  /// Drops local visit/order snapshots so cleared sync cards leave History too.
  Future<void> _discardLocalVisitArtifacts(List<OutboxEntry> entries) async {
    if (entries.isEmpty) return;

    final visitIds = <int>{};
    final taskIds = <int>{};

    for (final entry in entries) {
      if (entry.entityType == 'visit' && entry.localEntityId != null) {
        visitIds.add(entry.localEntityId!);
      }
      Map<String, dynamic> payload = const {};
      try {
        final decoded = jsonDecode(entry.payloadJson);
        if (decoded is Map) payload = Map<String, dynamic>.from(decoded);
      } catch (_) {}
      final visitId = ApiMap.asInt(payload['visit_id']);
      if (visitId != null) visitIds.add(visitId);
      final taskId = ApiMap.asInt(payload['task_id']);
      if (taskId != null) taskIds.add(taskId);
    }

    for (final visitId in visitIds) {
      final row = await _db.localVisitByAnyId(visitId);
      final ids = <int>{visitId};
      if (row != null) {
        ids.add(row.localVisitId);
        if (row.serverVisitId != null) ids.add(row.serverVisitId!);
        if (row.taskId != 0) taskIds.add(row.taskId);
      }
      for (final id in ids) {
        await _db.clearVisitCart(id);
        await _db.clearVisitProducts(id);
        await _db.replaceOrderLinesForVisit(id, const []);
        await _db.deleteDoc(ObDocKeys.visitDetail(id));
        await _db.deleteDoc(ObDocKeys.orderDetail(id));
      }
      if (row != null) {
        await _db.deleteLocalVisit(row.localVisitId);
      }
    }

    for (final taskId in taskIds) {
      if (taskId == 0) continue;
      // Only reset Today's Visits if nothing else remains queued for this task.
      if (!hasQueuedWorkForTask(taskId) && !isTaskQueuedForSync(taskId)) {
        await _db.clearTaskOverride(taskId);
      }
    }
  }

  void _registerObHandlers() {
    registerHandler('orderBooker', 'register_shop', _handleObRegisterShop);
    registerHandler('orderBooker', 'verify_on_site', _handleObVerifyOnSite);
    registerHandler('orderBooker', 'check_in', _handleObCheckIn);
    registerHandler('orderBooker', 'gps_attempt', _handleObGpsAttempt);
    registerHandler('orderBooker', 'submit_order', _handleObSubmitOrder);
    registerHandler(
      'orderBooker',
      'end_visit_without_order',
      _handleObEndWithoutOrder,
    );
    registerHandler('orderBooker', 'visit_notes', _handleObVisitNotes);
    registerHandler('orderBooker', 'task_notes', _handleObTaskNotes);
  }

  // ------------------------------------------------------------- shop setup

  Future<void> _handleObRegisterShop(
    OutboxEntry entry,
    Map<String, dynamic> payload,
  ) async {
    final localShopId = entry.localEntityId;
    if (localShopId != null &&
        await _db.serverIdFor('shop', localShopId) != null) {
      return;
    }

    // Never "adopt" an existing shop on the first attempt — phone/CNIC reuse
    // would skip POST and make the offline registration vanish on refresh.
    // Only reconcile after a prior failure (retry / duplicate response).
    if (entry.attempts > 0) {
      final existing = await _findRegisteredShopId(payload);
      if (existing != null) {
        await _bindShop(localShopId, existing);
        await _mergeShopIntoMineCacheById(existing);
        return;
      }
    }

    try {
      final data = await _api.postData(
        ApiEndpoints.obShopsRegister,
        data: payload,
      );
      final shopJson = ApiMap.asMap(data['shop']);
      if (shopJson == null) {
        throw ApiException(message: 'Shop registered but response was empty.');
      }
      final serverId =
          ApiMap.asInt(shopJson['shop_id']) ?? ApiMap.asInt(shopJson['id']);
      if (serverId == null || serverId <= 0) {
        throw ApiException(message: 'Shop registered without an id.');
      }
      await _bindShop(localShopId, serverId);
      await _mergeRegisteredShopIntoCache(shopJson);
    } on ApiException {
      // Server may reject a duplicate; adopt that shop so retry is not stuck.
      final existing = await _findRegisteredShopId(payload);
      if (existing != null) {
        await _bindShop(localShopId, existing);
        await _mergeShopIntoMineCacheById(existing);
        return;
      }
      rethrow;
    }
  }

  /// Matches an already-registered shop only when identity is strong enough.
  ///
  /// Phone or CNIC alone is not enough (same owner can have multiple shops /
  /// testers reuse numbers). Require matching name plus CNIC or phone, and
  /// when GPS is present prefer a nearby pin.
  Future<int?> _findRegisteredShopId(Map<String, dynamic> payload) async {
    String digits(Object? value) =>
        (value?.toString() ?? '').replaceAll(RegExp(r'\D'), '');

    final cnic = digits(payload['owner_cnic_number']);
    final phone = digits(payload['owner_phone']);
    final name = (payload['name']?.toString() ?? '').trim().toLowerCase();
    final lat = ApiMap.asDouble(payload['latitude']);
    final lng = ApiMap.asDouble(payload['longitude']);
    if (name.isEmpty) return null;

    try {
      final data = await _api.postData(ApiEndpoints.obShopsMine);
      for (final row in ApiMap.listOf(data, 'shops')) {
        final id = ApiMap.asInt(row['shop_id']) ?? ApiMap.asInt(row['id']);
        if (id == null || id <= 0) continue;

        final rowName = (row['name']?.toString() ?? '').trim().toLowerCase();
        if (rowName != name) continue;

        final rowCnic = digits(row['owner_cnic_number']);
        final rowPhone = digits(row['owner_phone']);
        final identityMatch =
            (cnic.length >= 13 && cnic == rowCnic) ||
            (phone.length >= 10 && phone == rowPhone);
        if (!identityMatch) continue;

        final rowLat = ApiMap.asDouble(row['latitude']);
        final rowLng = ApiMap.asDouble(row['longitude']);
        if (lat != null &&
            lng != null &&
            rowLat != null &&
            rowLng != null &&
            ((rowLat - lat).abs() >= 0.0005 ||
                (rowLng - lng).abs() >= 0.0005)) {
          // Same name+phone but clearly a different pin — keep looking.
          continue;
        }
        return id;
      }
    } catch (_) {
      // Treat lookup failure as "not found"; the POST is still guarded by the
      // id mapping check on the next attempt.
    }
    return null;
  }

  Future<void> _bindShop(int? localShopId, int serverShopId) async {
    if (localShopId == null) return;
    await _db.putIdMapping(
      entityType: 'shop',
      localId: localShopId,
      serverId: serverShopId,
    );
    await _db.patchLocalShop(
      localShopId,
      LocalShopsCompanion(
        serverShopId: Value(serverShopId),
        status: const Value('synced'),
      ),
    );
  }

  Future<void> _mergeRegisteredShopIntoCache(
    Map<String, dynamic> shopJson,
  ) async {
    if (!Get.isRegistered<OfflineCacheService>()) return;
    final cache = Get.find<OfflineCacheService>();
    final existing =
        await cache.readMap(OfflineCacheKeys.shopsMine) ??
        const <String, dynamic>{};
    final shops = List<Map<String, dynamic>>.from(
      ApiMap.listOf(existing, 'shops'),
    );
    final newId =
        ApiMap.asInt(shopJson['shop_id']) ?? ApiMap.asInt(shopJson['id']);
    if (newId != null) {
      shops.removeWhere((row) {
        final id = ApiMap.asInt(row['shop_id']) ?? ApiMap.asInt(row['id']);
        return id == newId;
      });
    }
    shops.insert(0, Map<String, dynamic>.from(shopJson));
    await cache.saveMap(OfflineCacheKeys.shopsMine, {'shops': shops});
  }

  Future<void> _mergeShopIntoMineCacheById(int serverShopId) async {
    if (!Get.isRegistered<OfflineCacheService>()) return;
    try {
      final data = await _api.postData(
        ApiEndpoints.obShopsGet,
        data: {'shop_id': serverShopId},
      );
      final shopJson = ApiMap.asMap(data['shop']) ?? data;
      await _mergeRegisteredShopIntoCache(shopJson);
    } catch (_) {
      // Cache stays as-is; My Shops still bridges via local row until mine returns.
    }
  }

  Future<void> _handleObVerifyOnSite(
    OutboxEntry entry,
    Map<String, dynamic> payload,
  ) async {
    final localVisitId = entry.localEntityId;
    if (localVisitId != null &&
        await _db.serverIdFor('visit', localVisitId) != null) {
      return;
    }

    final shopId = ApiMap.asInt(payload['shop_id']);
    final taskId = ApiMap.asInt(payload['task_id']);
    if (shopId == null || taskId == null) {
      throw ApiException(message: 'Missing shop or task for verification');
    }

    if (await _shopAlreadyVerified(shopId)) {
      final adopted =
          await _serverVisitIdForTask(taskId, openOnly: true) ??
          await _serverVisitIdForTask(taskId, openOnly: false);
      if (adopted != null) await _bindVisit(localVisitId, adopted);
      return;
    }

    final data = await _api.postData(
      ApiEndpoints.obShopsVerifyOnSite,
      data: payload,
    );
    final result = ObCheckInResult.fromJson(data);
    // Verification may or may not open the visit. When it does, the dependent
    // check-in entry short-circuits on the mapping written here.
    if (result.hasVisit) {
      await _bindVisit(localVisitId, result.visit!.visitId);
    }
  }

  Future<bool> _shopAlreadyVerified(int shopId) async {
    try {
      final data = await _api.postData(
        ApiEndpoints.obShopsGet,
        data: {'shop_id': shopId, 'include_photos': false},
      );
      final shop = ApiMap.asMap(data['shop']) ?? data;
      if (shop['needs_shop_setup'] == true) return false;
      return shop['field_verified'] == true;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------- check-in

  Future<void> _handleObCheckIn(
    OutboxEntry entry,
    Map<String, dynamic> payload,
  ) async {
    final localVisitId = entry.localEntityId;
    if (localVisitId != null &&
        await _db.serverIdFor('visit', localVisitId) != null) {
      return;
    }

    final taskId = ApiMap.asInt(payload['task_id']);
    if (taskId == null) throw ApiException(message: 'Missing task_id');

    // Only adopt an *open* visit. Adopting a closed one made end-visit fail
    // with "This visit is not in progress" while check-in looked synced.
    final adoptedOpen = await _serverVisitIdForTask(taskId, openOnly: true);
    if (adoptedOpen != null) {
      await _bindVisit(localVisitId, adoptedOpen);
      return;
    }

    final lat = ApiMap.asDouble(payload['latitude']);
    final lng = ApiMap.asDouble(payload['longitude']);
    if (lat == null || lng == null) {
      throw ApiException(message: 'Missing GPS for check-in');
    }

    try {
      final data = await _api.postData(
        ApiEndpoints.obTasksCheckIn,
        data: {
          'task_id': taskId,
          'latitude': lat,
          'longitude': lng,
          if (payload['distance_m'] != null)
            'distance_m': payload['distance_m'],
          if (payload['out_of_range'] != null)
            'out_of_range': payload['out_of_range'],
          if (payload['gps_accuracy_m'] != null)
            'gps_accuracy_m': payload['gps_accuracy_m'],
          if (payload['gps_max_m'] != null) 'gps_max_m': payload['gps_max_m'],
          if (payload['captured_at'] != null)
            'captured_at': payload['captured_at'],
        },
      );
      final result = ObCheckInResult.fromJson(data);
      if (result.hasVisit) {
        await _bindVisit(localVisitId, result.visit!.visitId);
        return;
      }
    } on ApiException {
      // Already checked in — adopt whatever the server has (open preferred).
      final existing = await _serverVisitIdForTask(taskId, openOnly: false);
      if (existing != null) {
        await _bindVisit(localVisitId, existing);
        return;
      }
      rethrow;
    }

    final adoptedAfterPost = await _serverVisitIdForTask(
      taskId,
      openOnly: false,
    );
    if (adoptedAfterPost != null) {
      await _bindVisit(localVisitId, adoptedAfterPost);
      return;
    }
    throw ApiException(message: 'Check-in did not return a visit');
  }

  /// Far / blocked GPS ping for the distributor panel. Never binds a visit.
  Future<void> _handleObGpsAttempt(
    OutboxEntry entry,
    Map<String, dynamic> payload,
  ) async {
    final taskId = ApiMap.asInt(payload['task_id']);
    final lat = ApiMap.asDouble(payload['latitude']);
    final lng = ApiMap.asDouble(payload['longitude']);
    if (taskId == null || lat == null || lng == null) {
      throw ApiException(message: 'Missing GPS attempt fields');
    }

    await _api.postData(
      ApiEndpoints.obTasksCheckIn,
      data: {
        'task_id': taskId,
        'latitude': lat,
        'longitude': lng,
        if (payload['shop_id'] != null) 'shop_id': payload['shop_id'],
        if (payload['shop_name'] != null) 'shop_name': payload['shop_name'],
        if (payload['visit_id'] != null) 'visit_id': payload['visit_id'],
        if (payload['distance_m'] != null) 'distance_m': payload['distance_m'],
        if (payload['out_of_range'] != null)
          'out_of_range': payload['out_of_range'],
        if (payload['gps_accuracy_m'] != null)
          'gps_accuracy_m': payload['gps_accuracy_m'],
        if (payload['gps_max_m'] != null) 'gps_max_m': payload['gps_max_m'],
        if (payload['captured_at'] != null)
          'captured_at': payload['captured_at'],
        if (payload['purpose'] != null) 'purpose': payload['purpose'],
        if (payload['client_request_id'] != null)
          'client_request_id': payload['client_request_id'],
        'blocked': true,
        'out_of_range': true,
      },
    );

    final requestId = ApiMap.asString(payload['client_request_id']);
    if (requestId != null && requestId.isNotEmpty) {
      await _db.markTelemetrySent(requestId);
    }
  }

  /// Server visit for [taskId] today.
  ///
  /// [openOnly] avoids binding a finished visit to a fresh offline check-in.
  Future<int?> _serverVisitIdForTask(
    int taskId, {
    required bool openOnly,
  }) async {
    try {
      final data = await _api.postData(ApiEndpoints.obVisitsActive);
      final visit = ApiMap.asMap(data['visit']);
      if (visit != null) {
        final id = ApiMap.asInt(visit['visit_id']) ?? ApiMap.asInt(visit['id']);
        if (ApiMap.asInt(visit['task_id']) == taskId && id != null && id > 0) {
          return id;
        }
      }
    } catch (_) {
      // Fall through to the day list.
    }

    try {
      final today = AppFormatter.apiDate(DateTime.now());
      final data = await _api.postData(
        ApiEndpoints.obVisitsMine,
        data: {'limit': 100, 'offset': 0, 'date_from': today, 'date_to': today},
      );
      int? closedId;
      for (final row in ApiMap.listOf(data, 'visits')) {
        if (ApiMap.asInt(row['task_id']) != taskId) continue;
        final id = ApiMap.asInt(row['visit_id']) ?? ApiMap.asInt(row['id']);
        if (id == null || id <= 0) continue;
        if (_visitRowIsOpen(row)) return id;
        closedId ??= id;
      }
      if (!openOnly) return closedId;
    } catch (_) {
      // No adoption possible; caller will create the visit.
    }
    return null;
  }

  bool _visitRowIsOpen(Map<String, dynamic> visit) {
    final outcome = ApiMap.asString(visit['outcome'])?.toLowerCase();
    if (outcome == 'order_placed' ||
        outcome == 'ended_without_order' ||
        outcome == 'no_order' ||
        outcome == 'no_sale') {
      return false;
    }
    final state = ApiMap.asString(visit['state'])?.toLowerCase();
    if (state == 'completed' ||
        state == 'closed' ||
        state == 'done' ||
        state == 'cancel' ||
        state == 'cancelled') {
      return false;
    }
    return true;
  }

  Future<void> _bindVisit(int? localVisitId, int serverVisitId) async {
    if (localVisitId == null || serverVisitId <= 0) return;
    await _db.putIdMapping(
      entityType: 'visit',
      localId: localVisitId,
      serverId: serverVisitId,
    );
    await _db.patchLocalVisit(
      localVisitId,
      LocalVisitsCompanion(serverVisitId: Value(serverVisitId)),
    );
    await _db.remapVisitLocalData(
      localVisitId: localVisitId,
      serverVisitId: serverVisitId,
    );
    await _remapVisitDetailDocs(localVisitId, serverVisitId);
    if (localVisitId != serverVisitId) {
      lastVisitRemap.value = VisitIdRemap(
        localId: localVisitId,
        serverId: serverVisitId,
      );
    }
  }

  Future<void> _remapVisitDetailDocs(
    int localVisitId,
    int serverVisitId,
  ) async {
    if (localVisitId == serverVisitId) return;
    for (final keyOf in [ObDocKeys.visitDetail, ObDocKeys.orderDetail]) {
      final localDoc = await _db.readDoc(keyOf(localVisitId));
      if (localDoc == null) continue;
      final serverDoc = await _db.readDoc(keyOf(serverVisitId));
      if (serverDoc != null) continue;
      try {
        final map = Map<String, dynamic>.from(
          jsonDecode(localDoc.jsonPayload) as Map,
        );
        map['visit_id'] = serverVisitId;
        map['pending_sync'] = false;
        await _db.saveDoc(keyOf(serverVisitId), jsonEncode(map));
      } catch (_) {
        await _db.saveDoc(keyOf(serverVisitId), localDoc.jsonPayload);
      }
    }
  }

  // ------------------------------------------------------------------ orders

  Future<void> _handleObSubmitOrder(
    OutboxEntry entry,
    Map<String, dynamic> payload,
  ) async {
    final visitId = ApiMap.asInt(payload['visit_id']);
    if (visitId == null) throw ApiException(message: 'Missing visit_id');

    if (await _visitHasOrder(visitId)) {
      await _markLocalVisitSynced(visitId);
      return;
    }

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
        data: {
          'visit_id': visitId,
          'latitude': lat,
          'longitude': lng,
          if (payload['distance_m'] != null)
            'distance_m': payload['distance_m'],
          if (payload['out_of_range'] != null)
            'out_of_range': payload['out_of_range'],
          if (payload['gps_accuracy_m'] != null)
            'gps_accuracy_m': payload['gps_accuracy_m'],
          if (payload['gps_max_m'] != null) 'gps_max_m': payload['gps_max_m'],
          if (payload['captured_at'] != null)
            'captured_at': payload['captured_at'],
        },
      );
    } on ApiException {
      if (await _visitHasOrder(visitId)) {
        await _markLocalVisitSynced(visitId);
        return;
      }
      rethrow;
    }

    if (!await _visitHasOrder(visitId)) {
      throw ApiException(message: 'Order submit did not produce an order');
    }
    await _refreshVisitDetailDocs(visitId);
    await _markLocalVisitSynced(visitId);
  }

  Future<void> _refreshVisitDetailDocs(int visitId) async {
    try {
      final data = await _api.postData(
        ApiEndpoints.obVisitsGet,
        data: {'visit_id': visitId},
      );
      final visitJson = ApiMap.asMap(data['visit']) ?? data;
      final encoded = jsonEncode(visitJson);
      await _db.saveDoc(ObDocKeys.visitDetail(visitId), encoded);
      await _db.saveDoc(ObDocKeys.orderDetail(visitId), encoded);
      final orderNumber =
          ApiMap.asString(visitJson['sale_order_name']) ??
          ApiMap.asString(visitJson['order_number']);
      if (orderNumber != null && orderNumber.isNotEmpty) {
        final local = await _db.localVisitByAnyId(
          visitId,
          userId: _currentUserId,
        );
        if (local != null) {
          await _db.patchLocalVisit(
            local.localVisitId,
            LocalVisitsCompanion(orderNumber: Value(orderNumber)),
          );
        }
      }
    } catch (_) {
      // Snapshot refresh is best-effort; order already exists on server.
    }
  }

  Future<void> _handleObEndWithoutOrder(
    OutboxEntry entry,
    Map<String, dynamic> payload,
  ) async {
    var visitId = ApiMap.asInt(payload['visit_id']);
    if (visitId == null) throw ApiException(message: 'Missing visit_id');

    if (await _visitAlreadyClosed(visitId)) {
      await _markLocalVisitSynced(visitId);
      return;
    }

    final notes = ApiMap.asString(payload['notes']) ?? '';

    try {
      await _api.postData(
        ApiEndpoints.obVisitsEndWithoutOrder,
        data: {'visit_id': visitId, 'notes': notes},
      );
    } on ApiException catch (e) {
      if (await _visitAlreadyClosed(visitId)) {
        await _markLocalVisitSynced(visitId);
        return;
      }

      // Check-in sometimes bound a finished visit, or the open visit moved.
      // Recover by ending the real open visit, or re-opening then ending.
      if (_isVisitNotInProgressMessage(e.message)) {
        final recovered = await _recoverEndWithoutOrder(
          entry: entry,
          payload: payload,
          notes: notes,
          failedVisitId: visitId,
        );
        if (recovered) return;
      }
      rethrow;
    }
    await _markLocalVisitSynced(visitId);
  }

  bool _isVisitNotInProgressMessage(String message) {
    final msg = message.toLowerCase();
    return msg.contains('not in progress') ||
        msg.contains('not checked in') ||
        msg.contains('no active visit') ||
        msg.contains('visit is closed') ||
        msg.contains('already closed') ||
        msg.contains('already ended');
  }

  /// Ends an open visit for the task, or check-in then end, so a stuck
  /// "Visit #-N / not in progress" entry can finish on retry.
  Future<bool> _recoverEndWithoutOrder({
    required OutboxEntry entry,
    required Map<String, dynamic> payload,
    required String notes,
    required int failedVisitId,
  }) async {
    final taskId = ApiMap.asInt(payload['task_id']);
    if (taskId == null) return false;

    final localForTask = await _db.localVisitForTask(
      taskId,
      userId: _currentUserId ?? '',
    );
    final localVisitId = entry.localEntityId ?? localForTask?.localVisitId;

    final openId = await _serverVisitIdForTask(taskId, openOnly: true);
    if (openId != null) {
      await _bindVisit(localVisitId, openId);
      await _api.postData(
        ApiEndpoints.obVisitsEndWithoutOrder,
        data: {'visit_id': openId, 'notes': notes},
      );
      await _markLocalVisitSynced(openId);
      return true;
    }

    if (await _visitAlreadyClosed(failedVisitId)) {
      await _markLocalVisitSynced(failedVisitId);
      return true;
    }

    final local = localVisitId == null
        ? null
        : await _db.localVisitById(localVisitId);
    final lat = ApiMap.asDouble(payload['latitude']) ?? local?.latitude;
    final lng = ApiMap.asDouble(payload['longitude']) ?? local?.longitude;
    if (lat == null || lng == null) return false;

    try {
      final data = await _api.postData(
        ApiEndpoints.obTasksCheckIn,
        data: {'task_id': taskId, 'latitude': lat, 'longitude': lng},
      );
      final result = ObCheckInResult.fromJson(data);
      final newVisitId = result.hasVisit
          ? result.visit!.visitId
          : await _serverVisitIdForTask(taskId, openOnly: true);
      if (newVisitId == null || newVisitId <= 0) return false;

      await _bindVisit(localVisitId, newVisitId);
      await _api.postData(
        ApiEndpoints.obVisitsEndWithoutOrder,
        data: {'visit_id': newVisitId, 'notes': notes},
      );
      await _markLocalVisitSynced(newVisitId);
      return true;
    } on ApiException catch (e) {
      final existing = await _serverVisitIdForTask(taskId, openOnly: true);
      if (existing == null) {
        // Last resort: if server insists nothing is open and the bound visit
        // is finished, treat end as done so the queue can clear.
        if (_isVisitNotInProgressMessage(e.message) &&
            await _visitAlreadyClosed(failedVisitId)) {
          await _markLocalVisitSynced(failedVisitId);
          return true;
        }
        return false;
      }
      await _bindVisit(localVisitId, existing);
      await _api.postData(
        ApiEndpoints.obVisitsEndWithoutOrder,
        data: {'visit_id': existing, 'notes': notes},
      );
      await _markLocalVisitSynced(existing);
      return true;
    }
  }

  Future<void> _markLocalVisitSynced(int serverVisitId) async {
    final local = await _db.localVisitByAnyId(
      serverVisitId,
      userId: _currentUserId,
    );
    if (local == null) return;
    await _db.patchLocalVisit(
      local.localVisitId,
      const LocalVisitsCompanion(
        status: Value('completed'),
        pendingSync: Value(false),
      ),
    );
    // Only now mark the task completed — local end/order must not look done
    // on the server until this outbox step succeeds.
    await _db.upsertTaskOverride(
      LocalTaskOverridesCompanion.insert(
        taskId: Value(local.taskId),
        status: Value(TaskStatus.completed.name),
        updatedAt: DateTime.now(),
      ),
    );
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
      return !_visitRowIsOpen(visit);
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

    // Collapse server duplicates first — keep one line per product_id.
    final serverByProduct = <int, Map<String, dynamic>>{};
    final extrasToRemove = <int>[];
    for (final line in serverLines) {
      final pid = ApiMap.asInt(line['product_id']);
      if (pid == null) continue;
      final lineId = ApiMap.asInt(line['line_id']) ?? ApiMap.asInt(line['id']);
      final existing = serverByProduct[pid];
      if (existing == null) {
        serverByProduct[pid] = line;
        continue;
      }
      final existingId =
          ApiMap.asInt(existing['line_id']) ?? ApiMap.asInt(existing['id']);
      // Keep the lower positive id as canonical; drop the other.
      if (lineId != null &&
          existingId != null &&
          lineId < existingId &&
          lineId > 0) {
        extrasToRemove.add(existingId);
        serverByProduct[pid] = line;
      } else if (lineId != null) {
        extrasToRemove.add(lineId);
      }
    }
    for (final lineId in extrasToRemove) {
      await _api.postData(
        ApiEndpoints.obVisitsLineRemove,
        data: {'line_id': lineId},
      );
    }

    final localByProduct = <int, Map<String, dynamic>>{};
    for (final line in lines) {
      final pid = ApiMap.asInt(line['product_id']);
      if (pid == null) continue;
      final existing = localByProduct[pid];
      if (existing == null) {
        localByProduct[pid] = line;
        continue;
      }
      final qty = ApiMap.asDouble(line['quantity']) ?? 0;
      final existingQty = ApiMap.asDouble(existing['quantity']) ?? 0;
      if (qty >= existingQty) localByProduct[pid] = line;
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
          data: {
            'visit_id': visitId,
            'product_id': productId,
            'quantity': qty,
            // Proposed/selling rate — required for discount approval path.
            'price_unit': price,
          },
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
          data: {'line_id': lineId, 'quantity': qty, 'price_unit': price},
        );
      }
    }

    // Line/add may ignore price_unit — reconcile proposed rates after adds.
    await _reconcileLinePrices(
      visitId: visitId,
      localByProduct: localByProduct,
    );
  }

  Future<void> _reconcileLinePrices({
    required int visitId,
    required Map<int, Map<String, dynamic>> localByProduct,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.obVisitsGet,
      data: {'visit_id': visitId},
    );
    final visit = ApiMap.asMap(data['visit']) ?? data;
    final serverLines = ApiMap.listOf(visit, 'lines');

    for (final server in serverLines) {
      final productId = ApiMap.asInt(server['product_id']);
      if (productId == null) continue;
      final local = localByProduct[productId];
      if (local == null) continue;

      final price = ApiMap.asDouble(local['price_unit']) ?? 0;
      final serverPrice = ApiMap.asDouble(server['price_unit']) ?? 0;
      if ((serverPrice - price).abs() <= 0.001) continue;

      final lineId =
          ApiMap.asInt(server['line_id']) ?? ApiMap.asInt(server['id']);
      if (lineId == null) continue;

      final qty =
          ApiMap.asDouble(local['quantity']) ??
          ApiMap.asDouble(server['quantity']) ??
          0;
      await _api.postData(
        ApiEndpoints.obVisitsLineUpdate,
        data: {'line_id': lineId, 'quantity': qty, 'price_unit': price},
      );
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

/// Local → server visit id swap published after a successful check-in flush.
class VisitIdRemap {
  const VisitIdRemap({required this.localId, required this.serverId});

  final int localId;
  final int serverId;
}
