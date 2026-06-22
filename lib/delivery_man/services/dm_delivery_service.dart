import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dm_delivery_order_model.dart';

class DmDeliveryService extends GetxService {
  DmDeliveryService(this._api);
  final ApiClient _api;

  Future<List<DmDeliveryOrderModel>> fetchDeliveries() async {
    final response = await _api.get(ApiEndpoints.deliveries);
    return (response.data as List<dynamic>)
        .map((e) => DmDeliveryOrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
