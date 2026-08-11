import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/media/app_ref_image.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_check_in_result.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_route_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_register_request.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_verify_on_site_request.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_zone_option.dart';

class ObShopService extends GetxService {
  ObShopService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  List<ObZoneOption>? _zonesCache;
  final Map<int?, List<ObRouteOption>> _routesCache = {};

  /// Session memory of full shop details (incl. photos). Avoids re-hitting
  /// `shops/get?include_photos` on every reopen in the same session.
  final Map<String, ObShopModel> _shopDetailMemory = {};

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

  /// Instant seed: memory → disk detail → my-shops list. Never hits network.
  Future<ObShopModel?> peekShop(String id) async {
    if (id.isEmpty) return null;
    final mem = _shopDetailMemory[id];
    if (mem != null) return mem;

    final detail = await _cache.readMap(OfflineCacheKeys.shopDetail(id));
    if (detail != null) {
      final shop = ObShopModel.fromJson(detail);
      _shopDetailMemory[id] = shop;
      return shop;
    }

    return _shopFromMineList(id);
  }

  Future<ObShopModel?> _shopFromMineList(String id) async {
    final cached = await _cache.readMap(OfflineCacheKeys.shopsMine);
    if (cached == null) return null;
    for (final shop in _parseShops(cached)) {
      if (shop.id == id) {
        rememberShop(shop);
        return shop;
      }
    }
    return null;
  }

  bool _hasLoadablePhotos(ObShopModel shop) {
    final photos = shop.verificationPhotos;
    return AppRefImage.isLoadable(photos.cnicFront) ||
        AppRefImage.isLoadable(photos.cnicBack) ||
        AppRefImage.isLoadable(photos.ownerPhoto) ||
        AppRefImage.isLoadable(photos.shopExterior);
  }

  Future<ObShopModel> fetchShop(
    String id, {
    bool includePhotos = false,
    bool force = false,
  }) async {
    if (!force) {
      final mem = _shopDetailMemory[id];
      if (mem != null && (!includePhotos || _hasLoadablePhotos(mem))) {
        return mem;
      }
    }

    final shopId = int.tryParse(id) ?? id;
    final data = await _api.postData(
      ApiEndpoints.obShopsGet,
      data: {'shop_id': shopId, 'include_photos': includePhotos},
    );
    final shopJson = ApiMap.asMap(data['shop']) ?? data;
    final shop = ObShopModel.fromJson(shopJson);
    _shopDetailMemory[id] = shop;
    // Persist metadata for offline reopen; strip huge base64 photo payloads.
    await _cache.saveMap(
      OfflineCacheKeys.shopDetail(id),
      shop.toJson(includePhotos: false),
    );
    return shop;
  }

  void rememberShop(ObShopModel shop) {
    if (shop.id.isEmpty) return;
    final existing = _shopDetailMemory[shop.id];
    if (existing != null &&
        _hasLoadablePhotos(existing) &&
        !_hasLoadablePhotos(shop)) {
      return;
    }
    _shopDetailMemory[shop.id] = shop;
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
    _shopDetailMemory.clear();
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
    final shop = ObShopModel.fromJson(shopJson);
    rememberShop(shop);
    return shop;
  }

  Future<ObCheckInResult> verifyOnSite(
    ObShopVerifyOnSiteRequest request,
  ) async {
    final data = await _api.postData(
      ApiEndpoints.obShopsVerifyOnSite,
      data: request.toJson(),
    );
    final result = ObCheckInResult.fromJson(data);
    // Force next detail open to refetch photos after verification.
    _shopDetailMemory.remove('${request.shopId}');
    await _cache.clearKeys([OfflineCacheKeys.shopDetail('${request.shopId}')]);
    return result;
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
