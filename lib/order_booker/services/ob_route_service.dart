import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_model.dart';

class ObRouteService extends GetxService {
  ObRouteService(this._api);
  final ApiClient _api;

  Future<List<ObRouteModel>> fetchRoutes() async {
    final response = await _api.get(ApiEndpoints.routes);
    final list = response.data as List<dynamic>;
    return list
        .map((e) => ObRouteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ObRouteModel> fetchRoute(String id) async {
    final response = await _api.get(ApiEndpoints.route(id));
    return ObRouteModel.fromJson(response.data as Map<String, dynamic>);
  }
}
