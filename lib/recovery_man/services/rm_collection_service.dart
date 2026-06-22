import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/rm_collection_model.dart';

class RmCollectionService extends GetxService {
  RmCollectionService(this._api);
  final ApiClient _api;

  Future<RmCollectionModel> recordCollection(
    Map<String, dynamic> payload,
  ) async {
    final response = await _api.post(ApiEndpoints.collections, data: payload);
    return RmCollectionModel.fromJson(response.data as Map<String, dynamic>);
  }
}
