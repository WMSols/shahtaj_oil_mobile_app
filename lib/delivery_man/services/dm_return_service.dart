import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dm_return_model.dart';

class DmReturnService extends GetxService {
  DmReturnService(this._api);
  final ApiClient _api;

  Future<DmReturnModel> createReturn(Map<String, dynamic> payload) async {
    final response = await _api.post(ApiEndpoints.returns, data: payload);
    return DmReturnModel.fromJson(response.data as Map<String, dynamic>);
  }
}
