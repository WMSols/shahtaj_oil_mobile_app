import 'dart:convert';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/history/ob_visit_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/history/ob_visit_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/sync/ob_day_bootstrap_service.dart';

class ObVisitService extends GetxService {
  ObVisitService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  AppDatabase? get _db =>
      Get.isRegistered<AppDatabase>() ? Get.find<AppDatabase>() : null;

  String? get _currentUserId {
    if (!Get.isRegistered<SessionService>()) return null;
    final id = Get.find<SessionService>().user.value?.id;
    return (id == null || id.isEmpty) ? null : id;
  }

  Future<ObVisitListResult> fetchMyVisits({
    int limit = 50,
    int offset = 0,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool forceNetwork = false,
  }) async {
    final cacheable =
        offset == 0 && dateFrom == null && dateTo == null && limit <= 50;

    final body = {
      'limit': limit,
      'offset': offset,
      if (dateFrom != null) 'date_from': AppFormatter.apiDate(dateFrom),
      if (dateTo != null) 'date_to': AppFormatter.apiDate(dateTo),
    };

    if (!cacheable) {
      // Dated and paged queries have no JSON cache, so offline they are served
      // from the bootstrapped history window instead of failing.
      if (_cache.shouldServeCacheFirst()) {
        final offline = await _visitsFromWindow(
          dateFrom: dateFrom,
          dateTo: dateTo,
          limit: limit,
          offset: offset,
        );
        if (offline != null) {
          return _withLocalVisits(offline, offset, dateFrom, dateTo);
        }
      }
      try {
        final data = await _api.postData(ApiEndpoints.obVisitsMine, data: body);
        return _withLocalVisits(
          ObVisitListResult.fromJson(data),
          offset,
          dateFrom,
          dateTo,
        );
      } catch (_) {
        final offline = await _visitsFromWindow(
          dateFrom: dateFrom,
          dateTo: dateTo,
          limit: limit,
          offset: offset,
        );
        if (offline != null) {
          return _withLocalVisits(offline, offset, dateFrom, dateTo);
        }
        rethrow;
      }
    }

    final result = await _cache.readThrough(
      key: OfflineCacheKeys.visitsMine,
      fetch: () => _api.postData(ApiEndpoints.obVisitsMine, data: body),
      parse: ObVisitListResult.fromJson,
      cacheFirst: _cache.cacheFirstFor(forceNetwork: forceNetwork),
    );
    return _withLocalVisits(result, offset, dateFrom, dateTo);
  }

  /// Puts visits captured offline at the top of the first page.
  ///
  /// Includes remapped visits that are still pending sync, and completed
  /// local visits missing from the server list cache.
  Future<ObVisitListResult> _withLocalVisits(
    ObVisitListResult result,
    int offset,
    DateTime? dateFrom,
    DateTime? dateTo,
  ) async {
    final db = _db;
    if (db == null || offset != 0) return result;

    final serverIds = result.visits.map((v) => v.visitId).toSet();
    final rows = await db.allLocalVisits(userId: _currentUserId ?? '');
    final pending = <ObVisitSummaryModel>[];
    final outbox = Get.isRegistered<SyncOutboxService>()
        ? Get.find<SyncOutboxService>()
        : null;

    for (final row in rows) {
      if (row.status != 'completed') continue;

      // Cleared Sync Center items leave no outbox — hide them from History.
      if (row.pendingSync && outbox != null) {
        final taskQueued =
            row.taskId != 0 && outbox.hasQueuedWorkForTask(row.taskId);
        if (!taskQueued) continue;
      }

      final displayId = row.serverVisitId ?? row.localVisitId;
      // Fully synced and already on the server list — avoid duplicates.
      if (row.serverVisitId != null &&
          !row.pendingSync &&
          serverIds.contains(row.serverVisitId)) {
        continue;
      }

      if (dateFrom != null &&
          row.checkedInAt.isBefore(
            DateTime(dateFrom.year, dateFrom.month, dateFrom.day),
          )) {
        continue;
      }
      if (dateTo != null &&
          row.checkedInAt.isAfter(
            DateTime(dateTo.year, dateTo.month, dateTo.day, 23, 59, 59),
          )) {
        continue;
      }

      final orderLines = await db.orderLinesForVisit(displayId);
      final altLines = orderLines.isEmpty
          ? await db.orderLinesForVisit(row.localVisitId)
          : orderLines;
      final cartFallback = altLines.isEmpty
          ? await db.linesForVisit(row.localVisitId)
          : const <VisitCartLine>[];
      final subtotal =
          row.subtotal ??
          (altLines.isNotEmpty
              ? altLines.fold<double>(
                  0,
                  (sum, line) => sum + (line.quantity * line.priceUnit),
                )
              : cartFallback.isEmpty
              ? null
              : cartFallback.fold<double>(
                  0,
                  (sum, line) => sum + (line.quantity * line.priceUnit),
                ));

      pending.add(
        ObVisitSummaryModel(
          visitId: displayId,
          shopId: row.shopId,
          taskId: row.taskId,
          shopName: row.shopName,
          checkedInAt: row.checkedInAt,
          checkedOutAt: row.completedAt,
          outcome: row.outcome == 'order_placed'
              ? VisitOutcome.orderPlaced
              : VisitOutcome.endedWithoutOrder,
          orderNumber: row.orderNumber,
          subtotal: subtotal,
        ),
      );
    }

    if (pending.isEmpty) return result;
    return ObVisitListResult(
      visits: [...pending, ...result.visits],
      total: result.total + pending.length,
    );
  }

  /// Slices the 30 day snapshot written by the day bootstrap.
  Future<ObVisitListResult?> _visitsFromWindow({
    DateTime? dateFrom,
    DateTime? dateTo,
    required int limit,
    required int offset,
  }) async {
    final db = _db;
    if (db == null) return null;
    final doc = await db.readDoc(ObDocKeys.visitHistoryWindow);
    if (doc == null) return null;

    Map<String, dynamic> decoded;
    try {
      decoded = Map<String, dynamic>.from(jsonDecode(doc.jsonPayload) as Map);
    } catch (_) {
      return null;
    }

    var rows = ApiMap.listOf(decoded, 'visits');
    if (dateFrom != null || dateTo != null) {
      final from = dateFrom == null
          ? null
          : DateTime(dateFrom.year, dateFrom.month, dateFrom.day);
      final to = dateTo == null
          ? null
          : DateTime(dateTo.year, dateTo.month, dateTo.day, 23, 59, 59);
      rows = rows
          .where((row) {
            final at =
                ApiMap.asDateTime(row['checked_in_at']) ??
                ApiMap.asDateTime(row['started_at']);
            if (at == null) return false;
            if (from != null && at.isBefore(from)) return false;
            if (to != null && at.isAfter(to)) return false;
            return true;
          })
          .toList(growable: false);
    }

    final total = rows.length;
    final page = rows.skip(offset).take(limit).toList(growable: false);
    return ObVisitListResult(
      visits: page.map(ObVisitSummaryModel.fromJson).toList(growable: false),
      total: total,
    );
  }

  Future<ObVisitDetailModel> fetchVisitDetail({required int visitId}) async {
    final db = _db;

    // Prefer a local snapshot (works for local and remapped server ids).
    final local = await _localVisitDetail(visitId);
    if (local != null && (visitId < 0 || _cache.shouldServeCacheFirst())) {
      return local;
    }

    if (_cache.shouldServeCacheFirst()) {
      final cached = await _readVisitDetailDoc(visitId);
      if (cached != null) return cached;
      if (local != null) return local;
      final fromWindow = await _visitDetailFromHistoryWindow(visitId);
      if (fromWindow != null) return fromWindow;
    }

    try {
      final data = await _api.postData(
        ApiEndpoints.obVisitsGet,
        data: {'visit_id': visitId},
      );
      final visitJson = ApiMap.asMap(data['visit']) ?? data;
      await db?.saveDoc(ObDocKeys.visitDetail(visitId), jsonEncode(visitJson));
      await db?.saveDoc(ObDocKeys.orderDetail(visitId), jsonEncode(visitJson));
      return ObVisitDetailModel.fromJson(visitJson);
    } catch (_) {
      final cached = await _readVisitDetailDoc(visitId);
      if (cached != null) return cached;
      if (local != null) return local;
      final fromWindow = await _visitDetailFromHistoryWindow(visitId);
      if (fromWindow != null) return fromWindow;
      rethrow;
    }
  }

  /// Last-resort detail built from the bootstrapped history list row.
  Future<ObVisitDetailModel?> _visitDetailFromHistoryWindow(int visitId) async {
    final db = _db;
    if (db == null) return null;
    final doc = await db.readDoc(ObDocKeys.visitHistoryWindow);
    if (doc == null) return null;
    try {
      final decoded = Map<String, dynamic>.from(
        jsonDecode(doc.jsonPayload) as Map,
      );
      for (final row in ApiMap.listOf(decoded, 'visits')) {
        final id = ApiMap.asInt(row['visit_id']) ?? ApiMap.asInt(row['id']);
        if (id != visitId) continue;
        await db.saveDoc(ObDocKeys.visitDetail(visitId), jsonEncode(row));
        return ObVisitDetailModel.fromJson(row);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  /// Builds detail for a visit that exists only on this device.
  Future<ObVisitDetailModel?> _localVisitDetail(int visitId) async {
    final cached = await _readVisitDetailDoc(visitId);
    if (cached != null) return cached;

    final db = _db;
    if (db == null) return null;

    // Resolve local ↔ server mapping so either id can find the row.
    var row = await db.localVisitByAnyId(visitId);
    if (row == null) {
      final mapped = await db.serverIdFor('visit', visitId);
      if (mapped != null) {
        final mappedDoc = await _readVisitDetailDoc(mapped);
        if (mappedDoc != null) return mappedDoc;
        row = await db.localVisitByAnyId(mapped);
      }
    }
    if (row == null) return null;

    // Prefer snapshot keyed by the other id when present.
    for (final id in {row.localVisitId, row.serverVisitId}.whereType<int>()) {
      if (id == visitId) continue;
      final alt = await _readVisitDetailDoc(id);
      if (alt != null) return alt;
    }

    final lines = await db.orderLinesForVisit(
      row.serverVisitId ?? row.localVisitId,
    );
    final alsoLocal = lines.isNotEmpty
        ? lines
        : await db.orderLinesForVisit(row.localVisitId);
    final cartFallback = alsoLocal.isEmpty
        ? await db.linesForVisit(row.serverVisitId ?? row.localVisitId)
        : const <VisitCartLine>[];
    final alsoCart = cartFallback.isEmpty
        ? await db.linesForVisit(row.localVisitId)
        : cartFallback;

    final mergedOrder = alsoLocal;
    final mergedCart = alsoCart;

    final orderNumber = row.orderNumber?.isNotEmpty == true
        ? row.orderNumber
        : (row.outcome == 'order_placed'
              ? ObDocKeys.pendingSyncOrderMarker
              : null);

    final detailLines = mergedOrder.isNotEmpty
        ? mergedOrder
              .map(
                (line) => ObVisitCartLineModel(
                  lineId: line.lineId,
                  productId: line.productId,
                  productName: line.productName,
                  quantity: line.quantity,
                  priceUnit: line.priceUnit,
                  unit: line.unit,
                ),
              )
              .toList(growable: false)
        : mergedCart
              .map(
                (line) => ObVisitCartLineModel(
                  lineId: line.lineId,
                  productId: line.productId,
                  productName: line.productName,
                  quantity: line.quantity,
                  priceUnit: line.priceUnit,
                  unit: line.unit,
                ),
              )
              .toList(growable: false);

    return ObVisitDetailModel(
      visitId: row.serverVisitId ?? row.localVisitId,
      shopId: row.shopId,
      shopName: row.shopName,
      checkedInAt: row.checkedInAt,
      checkedOutAt: row.completedAt,
      outcome: row.outcome == 'order_placed'
          ? VisitOutcome.orderPlaced
          : VisitOutcome.endedWithoutOrder,
      notes: row.notes,
      orderNumber: orderNumber,
      latitude: row.latitude,
      longitude: row.longitude,
      lines: detailLines,
      subtotal:
          row.subtotal ??
          detailLines.fold<double>(
            0,
            (sum, line) => sum + (line.quantity * line.priceUnit),
          ),
    );
  }

  Future<ObVisitDetailModel?> _readVisitDetailDoc(int visitId) async {
    final doc = await _db?.readDoc(ObDocKeys.visitDetail(visitId));
    if (doc == null) return null;
    try {
      return ObVisitDetailModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(doc.jsonPayload) as Map),
      );
    } catch (_) {
      return null;
    }
  }
}
