import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';

class ObShopService extends GetxService {
  ObShopService(this._api);
  final ApiClient _api;

  Future<List<ObShopModel>> fetchShops() async {
    final response = await _api.get(ApiEndpoints.shops);
    final list = response.data as List<dynamic>;
    return list
        .map((e) => ObShopModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ObShopModel> fetchShop(String id) async {
    final response = await _api.get(ApiEndpoints.shop(id));
    return ObShopModel.fromJson(response.data as Map<String, dynamic>);
  }
}
