// ignore_for_file: unused_field

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_detail_model.dart';

class ObOrderDetailService extends GetxService {
  ObOrderDetailService(this._api);

  final ApiClient _api;

  Future<ObOrderDetailModel> fetchOrderDetail(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final detail = AppMockData.obOrderDetail(orderId);
    if (detail == null) throw Exception('Order not found');
    return detail;

    // final response = await _api.get(
    //   ApiEndpoints.obVisitsGet,
    //   queryParameters: {'order_id': int.tryParse(orderId) ?? orderId},
    // );
    // return ObOrderDetailModel.fromJson(response.data as Map<String, dynamic>);
  }
}
