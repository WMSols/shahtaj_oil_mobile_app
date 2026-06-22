import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_model.dart';

class ObOrderService extends GetxService {
  ObOrderService(this._api);
  final ApiClient _api;

  Future<ObOrderModel> createOrder(Map<String, dynamic> payload) async {
    final response = await _api.post(ApiEndpoints.orders, data: payload);
    return ObOrderModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ObOrderModel> fetchOrder(String id) async {
    final response = await _api.get(ApiEndpoints.order(id));
    return ObOrderModel.fromJson(response.data as Map<String, dynamic>);
  }
}
