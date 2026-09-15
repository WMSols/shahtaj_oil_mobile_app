import 'dart:convert';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
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
  /// Only visits the server has never seen are added, so nothing is listed
  /// twice once the check-in syncs.
  Future<ObVisitListResult> _withLocalVisits(
    ObVisitListResult result,
    int offset,
    DateTime? dateFrom,
    DateTime? dateTo,
  ) async {
    final db = _db;
    if (db == null || offset != 0) return result;

    final rows = await db.allLocalVisits(userId: _currentUserId ?? '');
    final pending = <ObVisitSummaryModel>[];
    for (final row in rows) {
      if (row.serverVisitId != null) continue;
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
      pending.add(
        ObVisitSummaryModel(
          visitId: row.localVisitId,
          shopId: row.shopId,
          taskId: row.taskId,
          shopName: row.shopName,
          checkedInAt: row.checkedInAt,
          checkedOutAt: row.completedAt,
          outcome: row.outcome == 'order_placed'
              ? VisitOutcome.orderPlaced
              : VisitOutcome.endedWithoutOrder,
          orderNumber: row.orderNumber,
          subtotal: await _localVisitSubtotal(row.localVisitId),
        ),
      );
    }

    if (pending.isEmpty) return result;
    return ObVisitListResult(
      visits: [...pending, ...result.visits],
      total: result.total + pending.length,
    );
  }

  Future<double?> _localVisitSubtotal(int localVisitId) async {
    final db = _db;
    if (db == null) return null;
    final lines = await db.linesForVisit(localVisitId);
    if (lines.isEmpty) return null;
    return lines.fold<double>(
      0,
      (sum, line) => sum + (line.quantity * line.priceUnit),
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

    if (visitId < 0) {
      final local = await _localVisitDetail(visitId);
      if (local != null) return local;
    }

    if (_cache.shouldServeCacheFirst()) {
      final cached = await _readVisitDetailDoc(visitId);
      if (cached != null) return cached;
    }

    try {
      final data = await _api.postData(
        ApiEndpoints.obVisitsGet,
        data: {'visit_id': visitId},
      );
      final visitJson = ApiMap.asMap(data['visit']) ?? data;
      await db?.saveDoc(ObDocKeys.visitDetail(visitId), jsonEncode(visitJson));
      return ObVisitDetailModel.fromJson(visitJson);
    } catch (_) {
      final cached = await _readVisitDetailDoc(visitId);
      if (cached != null) return cached;
      rethrow;
    }
  }

  /// Builds detail for a visit that exists only on this device.
  Future<ObVisitDetailModel?> _localVisitDetail(int localVisitId) async {
    final db = _db;
    if (db == null) return null;
    final row = await db.localVisitById(localVisitId);
    if (row == null) return null;

    final lines = await db.linesForVisit(localVisitId);
    return ObVisitDetailModel(
      visitId: row.localVisitId,
      shopId: row.shopId,
      shopName: row.shopName,
      checkedInAt: row.checkedInAt,
      checkedOutAt: row.completedAt,
      outcome: row.outcome == 'order_placed'
          ? VisitOutcome.orderPlaced
          : VisitOutcome.endedWithoutOrder,
      notes: row.notes,
      orderNumber: row.orderNumber,
      latitude: row.latitude,
      longitude: row.longitude,
      lines: lines
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
          .toList(growable: false),
      subtotal: lines.fold<double>(
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
