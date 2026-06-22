import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_model.dart';

class ObVisitService extends GetxService {
  ObVisitService(this._api);
  final ApiClient _api;

  Future<ObVisitModel> checkIn(String shopId) async {
    final response = await _api.post(
      ApiEndpoints.visits,
      data: {'shop_id': shopId},
    );
    return ObVisitModel.fromJson(response.data as Map<String, dynamic>);
  }
}
