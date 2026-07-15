import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_line_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_detail_model.dart';

/// Order detail is served by `visits/get` (no dedicated orders API).
class ObOrderDetailService extends GetxService {
  ObOrderDetailService(this._api);

  final ApiClient _api;

  ObOrderDetailModel fromVisitDetail(ObVisitDetailModel visit) {
    return ObOrderDetailModel(
      id: visit.orderId?.toString() ?? visit.orderNumber ?? '${visit.visitId}',
      orderNumber: visit.orderNumber ?? 'SO-${visit.visitId}',
      shopId: visit.shopId,
      shopName: visit.shopName,
      status: OrderStatus.submitted,
      lines: visit.lines
          .map(
            (line) => ObOrderLineModel(
              productId: '${line.productId}',
              productName: line.productName,
              quantity: line.quantity,
              unitPrice: line.priceUnit,
            ),
          )
          .toList(growable: false),
      subtotal: visit.subtotal,
      createdAt: visit.checkedOutAt ?? visit.checkedInAt,
      visitId: visit.visitId,
    );
  }

  /// [visitId] is the visit id from history / dashboard recent orders.
  Future<ObOrderDetailModel> fetchOrderDetail(String visitId) async {
    final id = int.tryParse(visitId.trim());
    if (id == null) {
      throw ApiException(message: 'Invalid visit id for order detail.');
    }

    final data = await _api.postData(
      ApiEndpoints.obVisitsGet,
      data: {'visit_id': id},
    );
    final visitJson = ApiMap.asMap(data['visit']) ?? data;
    return ObOrderDetailModel.fromVisitJson(visitJson);
  }
}
