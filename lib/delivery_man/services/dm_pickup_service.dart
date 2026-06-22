import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dm_pickup_model.dart';

class DmPickupService extends GetxService {
  DmPickupService(this._api);
  final ApiClient _api;

  Future<DmPickupModel> confirmPickup(String deliveryId) async {
    final response = await _api.post(
      ApiEndpoints.pickups,
      data: {'delivery_id': deliveryId},
    );
    return DmPickupModel.fromJson(response.data as Map<String, dynamic>);
  }
}
