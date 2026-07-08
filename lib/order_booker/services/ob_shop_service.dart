// ignore_for_file: unused_field

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_edit_request.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_register_request.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_zone_option.dart';

class ObShopService extends GetxService {
  ObShopService(this._api);
  final ApiClient _api;

  Future<List<ObShopModel>> fetchShops() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return AppMockData.obShops;
    // Swap with API when ready:
    // final response = await _api.get(ApiEndpoints.shops);
    // final list = response.data as List<dynamic>;
    // return list
    //     .map((e) => ObShopModel.fromJson(e as Map<String, dynamic>))
    //     .toList();
  }

  Future<ObShopModel> fetchShop(String id, {bool includePhotos = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final normalized = int.tryParse(id);
    final prefixed = normalized != null
        ? 'shop-${normalized.toString().padLeft(3, '0')}'
        : id;
    try {
      return AppMockData.obShops.firstWhere(
        (shop) => shop.id == id || shop.id == prefixed,
      );
    } catch (_) {
      // Swap with API when ready:
      // final response = await _api.get(
      //   ApiEndpoints.obShopsGet,
      //   queryParameters: {
      //     'shop_id': normalized ?? id,
      //     'include_photos': includePhotos,
      //   },
      // );
      // return ObShopModel.fromJson(response.data as Map<String, dynamic>);
      throw Exception('Shop not found');
    }
  }

  Future<List<ObZoneOption>> fetchZones() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return AppMockData.obZones;
  }

  Future<List<ObRouteOption>> fetchRoutes({int? zoneId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final routes = AppMockData.obRoutes;
    if (zoneId == null) return routes;
    return routes.where((route) => route.zoneId == zoneId).toList();
  }

  Future<void> registerShop(ObShopRegisterRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    // Swap with API when ready:
    // await _api.post(ApiEndpoints.shops, data: request.toJson());
  }

  Future<void> updateShop(ObShopEditRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
    // Swap with API when ready:
    // await _api.post(ApiEndpoints.obShopsGet, data: request.toJson());
  }
}
