import 'dart:convert';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/sync/ob_day_bootstrap_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/history/ob_visit_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_line_model.dart';

/// Order detail is served by `visits/get` (no dedicated orders API).
class ObOrderDetailService extends GetxService {
  ObOrderDetailService(this._api);

  final ApiClient _api;

  Future<ObOrderDetailModel> fromVisitDetail(ObVisitDetailModel visit) async {
    return ObOrderDetailModel(
      id: visit.orderId?.toString() ?? visit.orderNumber ?? '${visit.visitId}',
      orderNumber: visit.orderNumber ?? 'SO-${visit.visitId}',
      shopId: visit.shopId,
      shopName: visit.shopName,
      lines: visit.lines
          .map(
            (line) => ObOrderLineModel(
              productId: '${line.productId}',
              productName: line.productName,
              quantity: line.quantity,
              unitPrice: line.priceUnit,
              listPrice: line.priceUnit,
            ),
          )
          .toList(growable: false),
      subtotal: visit.subtotal,
      createdAt: visit.checkedOutAt ?? visit.checkedInAt,
      visitId: visit.visitId,
      approval: visit.approval,
      creditWouldExceed: visit.creditWouldExceed,
    );
  }

  /// [visitId] is the visit id from history / dashboard recent orders.
  Future<ObOrderDetailModel> fetchOrderDetail(String visitId) async {
    final id = int.tryParse(visitId.trim());
    if (id == null) {
      throw ApiException(message: 'Invalid visit id for order detail.');
    }

    if (_shouldServeCacheFirst) {
      final cached = await _readCached(id);
      if (cached != null) return cached;
      final fromVisit = await _fromLocalVisitDoc(id);
      if (fromVisit != null) return fromVisit;
    }

    try {
      final data = await _api.postData(
        ApiEndpoints.obVisitsGet,
        data: {'visit_id': id},
      );
      final visitJson = ApiMap.asMap(data['visit']) ?? data;
      await _db?.saveDoc(ObDocKeys.orderDetail(id), jsonEncode(visitJson));
      await _db?.saveDoc(ObDocKeys.visitDetail(id), jsonEncode(visitJson));
      return ObOrderDetailModel.fromVisitJson(visitJson);
    } catch (_) {
      final cached = await _readCached(id);
      if (cached != null) return cached;
      final fromVisit = await _fromLocalVisitDoc(id);
      if (fromVisit != null) return fromVisit;
      rethrow;
    }
  }

  Future<ObOrderDetailModel?> _fromLocalVisitDoc(int visitId) async {
    final doc = await _db?.readDoc(ObDocKeys.visitDetail(visitId));
    if (doc == null) return null;
    try {
      return ObOrderDetailModel.fromVisitJson(
        Map<String, dynamic>.from(jsonDecode(doc.jsonPayload) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  AppDatabase? get _db =>
      Get.isRegistered<AppDatabase>() ? Get.find<AppDatabase>() : null;

  bool get _shouldServeCacheFirst =>
      Get.isRegistered<OfflineCacheService>() &&
      Get.find<OfflineCacheService>().shouldServeCacheFirst();

  Future<ObOrderDetailModel?> _readCached(int visitId) async {
    final doc = await _db?.readDoc(ObDocKeys.orderDetail(visitId));
    if (doc == null) return null;
    try {
      return ObOrderDetailModel.fromVisitJson(
        Map<String, dynamic>.from(jsonDecode(doc.jsonPayload) as Map),
      );
    } catch (_) {
      return null;
    }
  }
}
