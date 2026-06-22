import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/rm_handover_model.dart';

class RmHandoverService extends GetxService {
  RmHandoverService(this._api);
  final ApiClient _api;

  Future<RmHandoverModel> createHandover(Map<String, dynamic> payload) async {
    final response = await _api.post(ApiEndpoints.handovers, data: payload);
    return RmHandoverModel.fromJson(response.data as Map<String, dynamic>);
  }
}
