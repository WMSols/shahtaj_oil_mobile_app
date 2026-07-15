import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_edit_request.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_register_request.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_zone_option.dart';

class ObShopService extends GetxService {
  ObShopService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  List<ObZoneOption>? _zonesCache;
  final Map<int?, List<ObRouteOption>> _routesCache = {};

  Future<List<ObShopModel>> fetchShops() {
    return _cache.readThrough(
      key: OfflineCacheKeys.shopsMine,
      fetch: () => _api.postData(ApiEndpoints.obShopsMine),
      parse: _parseShops,
    );
  }

  Future<void> persistShops(List<ObShopModel> shops) async {
    await _cache.saveMap(OfflineCacheKeys.shopsMine, {
      'shops': shops.map((shop) => shop.toJson()).toList(growable: false),
    });
  }

  Future<ObShopModel> fetchShop(String id, {bool includePhotos = false}) async {
    final shopId = int.tryParse(id) ?? id;
    final data = await _api.postData(
      ApiEndpoints.obShopsGet,
      data: {'shop_id': shopId, 'include_photos': includePhotos},
    );
    final shopJson = ApiMap.asMap(data['shop']) ?? data;
    return ObShopModel.fromJson(shopJson);
  }

  Future<List<ObZoneOption>> fetchZones({bool force = false}) async {
    if (!force && _zonesCache != null) return _zonesCache!;

    final zones = await _cache.readThrough(
      key: OfflineCacheKeys.zones,
      fetch: () => _api.postData(ApiEndpoints.obZonesList),
      parse: _parseZones,
    );
    _zonesCache = zones;
    return zones;
  }

  Future<List<ObRouteOption>> fetchRoutes({
    int? zoneId,
    bool force = false,
  }) async {
    if (!force && _routesCache.containsKey(zoneId)) {
      return _routesCache[zoneId]!;
    }

    final key = OfflineCacheKeys.routes(zoneId);
    var routes = await _cache.readThrough(
      key: key,
      fetch: () =>
          _api.postData(ApiEndpoints.obRoutesList, data: {'zone_id': ?zoneId}),
      parse: _parseRoutes,
    );
    if (zoneId != null) {
      routes = routes
          .where((route) => route.zoneId == zoneId || route.zoneId == 0)
          .toList(growable: false);
    }
    _routesCache[zoneId] = routes;
    return routes;
  }

  void clearLookupCache() {
    _zonesCache = null;
    _routesCache.clear();
  }

  Future<ObShopModel> registerShop(ObShopRegisterRequest request) async {
    final data = await _api.postData(
      ApiEndpoints.obShopsRegister,
      data: request.toJson(),
    );
    final shopJson = ApiMap.asMap(data['shop']);
    if (shopJson == null) {
      throw ApiException(message: 'Shop registered but response was empty.');
    }
    return ObShopModel.fromJson(shopJson);
  }

  Future<void> updateShop(ObShopEditRequest request) async {
    // Shahtaj v1 has shops/register + shops/get/mine only — no update endpoint yet.
    throw ApiException(
      message: 'Shop update is not available on the server yet.',
    );
  }

  List<ObShopModel> _parseShops(Map<String, dynamic> data) {
    return ApiMap.listOf(
      data,
      'shops',
    ).map(ObShopModel.fromJson).toList(growable: false);
  }

  List<ObZoneOption> _parseZones(Map<String, dynamic> data) {
    final rows = ApiMap.listOf(data, 'zones');
    if (rows.isNotEmpty) {
      return rows.map(ObZoneOption.fromJson).toList(growable: false);
    }
    final items = ApiMap.listOf(data, 'items');
    if (items.isNotEmpty) {
      return items.map(ObZoneOption.fromJson).toList(growable: false);
    }
    final bare = ApiMap.asMapList(data['value']);
    if (bare.isNotEmpty) {
      return bare.map(ObZoneOption.fromJson).toList(growable: false);
    }
    return const [];
  }

  List<ObRouteOption> _parseRoutes(Map<String, dynamic> data) {
    final rows = ApiMap.listOf(data, 'routes');
    if (rows.isNotEmpty) {
      return rows.map(ObRouteOption.fromJson).toList(growable: false);
    }
    final items = ApiMap.listOf(data, 'items');
    if (items.isNotEmpty) {
      return items.map(ObRouteOption.fromJson).toList(growable: false);
    }
    final bare = ApiMap.asMapList(data['value']);
    if (bare.isNotEmpty) {
      return bare.map(ObRouteOption.fromJson).toList(growable: false);
    }
    return const [];
  }
}
