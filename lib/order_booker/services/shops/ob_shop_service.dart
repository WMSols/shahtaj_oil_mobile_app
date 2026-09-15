import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:get/get.dart' hide Value;

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/local_media_store.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/sync/outbox_payload.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/media/app_ref_image.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_check_in_result.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_route_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_register_request.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_zone_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_session_service.dart';

/// Outcome of a shop registration attempt.
class ObShopRegisterResult {
  const ObShopRegisterResult({required this.shop, required this.queued});

  final ObShopModel shop;
  final bool queued;
}

/// Outcome of a shop verification attempt.
class ObVerifySubmitResult {
  const ObVerifySubmitResult({required this.queued, this.visit, this.message});

  final bool queued;
  final ObActiveVisitModel? visit;
  final String? message;

  bool get hasVisit => visit != null && visit!.visitId != 0;
}

class ObShopService extends GetxService {
  ObShopService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  AppDatabase get _db => Get.find<AppDatabase>();

  SyncOutboxService get _outbox => Get.find<SyncOutboxService>();

  LocalMediaStore get _media => Get.find<LocalMediaStore>();

  ObVisitSessionService? get _session =>
      Get.isRegistered<ObVisitSessionService>()
      ? Get.find<ObVisitSessionService>()
      : null;

  bool get _canReachServer {
    if (!Get.isRegistered<ConnectivityService>()) return true;
    final connectivity = Get.find<ConnectivityService>();
    if (!connectivity.isOnline.value) return false;
    return connectivity.quality.value != NetworkQuality.weak;
  }

  static bool _isTransient(String message) {
    final msg = message.toLowerCase();
    return msg.contains('timed out') ||
        msg.contains('timeout') ||
        msg.contains('internet') ||
        msg.contains('connection') ||
        msg.contains('socket') ||
        msg.contains('network') ||
        msg.contains('host');
  }

  List<ObZoneOption>? _zonesCache;
  final Map<int?, List<ObRouteOption>> _routesCache = {};

  /// Session memory of full shop details (incl. photos). Avoids re-hitting
  /// `shops/get?include_photos` on every reopen in the same session.
  final Map<String, ObShopModel> _shopDetailMemory = {};

  Future<List<ObShopModel>> fetchShops({bool forceNetwork = false}) async {
    final shops = await _cache.readThrough(
      key: OfflineCacheKeys.shopsMine,
      fetch: () => _api.postData(ApiEndpoints.obShopsMine),
      parse: _parseShops,
      cacheFirst: _cache.cacheFirstFor(forceNetwork: forceNetwork),
    );
    return _withLocalShops(shops);
  }

  /// Shops registered offline appear immediately, ahead of the synced list.
  Future<List<ObShopModel>> _withLocalShops(List<ObShopModel> shops) async {
    if (!Get.isRegistered<AppDatabase>()) return shops;
    final rows = await _db.allLocalShops(userId: _currentUserId ?? '');
    if (rows.isEmpty) return shops;

    final pending = <ObShopModel>[];
    for (final row in rows) {
      // Once synced the server list is authoritative.
      if (row.serverShopId != null) continue;
      pending.add(localShopToModel(row));
    }
    if (pending.isEmpty) return shops;
    return [...pending, ...shops];
  }

  ObShopModel localShopToModel(LocalShop row) => ObShopModel(
    id: '${row.localShopId}',
    name: row.name,
    ownerName: row.ownerName,
    ownerCnicNumber: row.ownerCnic,
    phone: row.ownerPhone,
    latitude: row.latitude,
    longitude: row.longitude,
    shopType: row.shopCategory == ShopType.cash.name
        ? ShopType.cash
        : ShopType.credit,
    status: ShopStatus.pending,
  );

  /// A shop id below zero exists only on this device.
  static bool isLocalShopId(String id) => (int.tryParse(id) ?? 0) < 0;

  Future<void> persistShops(List<ObShopModel> shops) async {
    // Local-only shops live in Drift; keeping them out of the server snapshot
    // stops them showing twice once they sync.
    final synced = shops.where((shop) => !isLocalShopId(shop.id));
    await _cache.saveMap(OfflineCacheKeys.shopsMine, {
      'shops': synced.map((shop) => shop.toJson()).toList(growable: false),
    });
  }

  /// Instant seed: memory → disk detail → my-shops list. Never hits network.
  Future<ObShopModel?> peekShop(String id) async {
    if (id.isEmpty) return null;
    final mem = _shopDetailMemory[id] ?? _shopDetailMemory[_altId(id)];
    if (mem != null) return mem;

    for (final key in {id, _altId(id)}) {
      if (key.isEmpty) continue;
      final detail = await _cache.readMap(OfflineCacheKeys.shopDetail(key));
      if (detail != null) {
        final shop = ObShopModel.fromJson(detail);
        rememberShop(shop);
        return shop;
      }
    }

    return _shopFromMineList(id);
  }

  String _altId(String id) {
    final asInt = int.tryParse(id.trim());
    if (asInt == null) return id.trim();
    return asInt.toString();
  }

  Future<ObShopModel?> _shopFromMineList(String id) async {
    final cached = await _cache.readMap(OfflineCacheKeys.shopsMine);
    if (cached == null) return null;
    final want = id.trim();
    final wantInt = int.tryParse(want);
    for (final shop in _parseShops(cached)) {
      if (shop.id == want ||
          shop.id.trim() == want ||
          (wantInt != null && int.tryParse(shop.id) == wantInt)) {
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
    if (isLocalShopId(id) && Get.isRegistered<AppDatabase>()) {
      final row = await _db.localShopById(
        int.parse(id),
        userId: _currentUserId,
      );
      if (row != null) return localShopToModel(row);
    }

    if (!force) {
      final mem = _shopDetailMemory[id];
      if (mem != null && (!includePhotos || _hasLoadablePhotos(mem))) {
        return mem;
      }
    }

    // Offline the saved detail is the only truth available.
    if (!_canReachServer) {
      final cached = await peekShop(id);
      if (cached != null) return cached;
    }

    final shopId = int.tryParse(id) ?? id;
    final Map<String, dynamic> data;
    try {
      data = await _api.postData(
        ApiEndpoints.obShopsGet,
        data: {'shop_id': shopId, 'include_photos': includePhotos},
      );
    } catch (_) {
      final cached = await peekShop(id);
      if (cached != null) return cached;
      rethrow;
    }
    final shopJson = ApiMap.asMap(data['shop']) ?? data;
    final prior = _shopDetailMemory[id] ?? await peekShop(id);
    // Distributor / panel shops often have full credit on tasks/today but a
    // thinner shops/get payload — keep prior credit numbers when missing.
    final shop = ObShopModel.fromJson(shopJson).mergeCreditFrom(prior);
    _shopDetailMemory[id] = shop;
    _shopDetailMemory[shop.id] = shop;
    // Persist metadata for offline reopen; strip huge base64 photo payloads.
    await _cache.saveMap(
      OfflineCacheKeys.shopDetail(id),
      shop.toJson(includePhotos: false),
    );
    if (shop.id.isNotEmpty && shop.id != id) {
      await _cache.saveMap(
        OfflineCacheKeys.shopDetail(shop.id),
        shop.toJson(includePhotos: false),
      );
    }
    return shop;
  }

  void rememberShop(ObShopModel shop) {
    if (shop.id.isEmpty) return;
    final existing = _shopDetailMemory[shop.id];
    if (existing != null &&
        _hasLoadablePhotos(existing) &&
        !_hasLoadablePhotos(shop)) {
      _shopDetailMemory[shop.id] = shop.mergeCreditFrom(existing);
      return;
    }
    _shopDetailMemory[shop.id] = shop.mergeCreditFrom(existing);
  }

  /// Seeds session shop memory from nested `shop` objects on today's tasks.
  void rememberShopsFromTasksPayload(Map<String, dynamic> data) {
    final rawTasks = data['tasks'];
    if (rawTasks is! List) return;
    for (final raw in rawTasks) {
      if (raw is! Map) continue;
      final shopJson = ApiMap.asMap(raw['shop']);
      if (shopJson == null) continue;
      rememberShop(ObShopModel.fromJson(shopJson));
    }
  }

  Future<List<ObZoneOption>> fetchZones({bool force = false}) async {
    if (!force && _zonesCache != null) return _zonesCache!;

    final zones = await _cache.readThrough(
      key: OfflineCacheKeys.zones,
      fetch: () => _api.postData(ApiEndpoints.obZonesList),
      parse: _parseZones,
      cacheFirst: _cache.cacheFirstFor(forceNetwork: force),
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
      cacheFirst: _cache.cacheFirstFor(forceNetwork: force),
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

  /// Registers online when possible, otherwise stores the shop locally and
  /// queues `shops/register`. The shop is usable in My Shops either way.
  Future<ObShopRegisterResult> registerShop(
    ObShopRegisterRequest request, {
    Map<String, Uint8List> photos = const {},
  }) async {
    if (_canReachServer) {
      try {
        final data = await _api.postData(
          ApiEndpoints.obShopsRegister,
          data: request.toJson(),
        );
        final shopJson = ApiMap.asMap(data['shop']);
        if (shopJson == null) {
          throw ApiException(
            message: 'Shop registered but response was empty.',
          );
        }
        final shop = ObShopModel.fromJson(shopJson);
        rememberShop(shop);
        return ObShopRegisterResult(shop: shop, queued: false);
      } on ApiException catch (e) {
        if (!_isTransient(e.message)) rethrow;
      }
    }

    return ObShopRegisterResult(
      shop: await _queueShopRegistration(request, photos),
      queued: true,
    );
  }

  Future<ObShopModel> _queueShopRegistration(
    ObShopRegisterRequest request,
    Map<String, Uint8List> photos,
  ) async {
    final localShopId = await _db.nextLocalShopId();

    // Photo bytes go to disk; the payload only carries references.
    final payload = Map<String, dynamic>.from(request.toJson())
      ..remove('owner_cnic_front')
      ..remove('owner_cnic_back')
      ..remove('owner_photo')
      ..remove('shop_exterior_photo');
    for (final photo in photos.entries) {
      final mediaId = await _media.save(
        photo.value,
        purpose: 'register_${photo.key}',
      );
      payload[photo.key] = OutboxPayload.mediaRef(mediaId);
    }

    await _db.upsertLocalShop(
      LocalShopsCompanion.insert(
        localShopId: Value(localShopId),
        name: request.name,
        ownerName: Value(request.ownerName),
        ownerPhone: Value(request.ownerPhone),
        ownerCnic: Value(request.ownerCnic),
        latitude: Value(request.latitude),
        longitude: Value(request.longitude),
        shopCategory: Value(request.shopType.name),
        payloadJson: jsonEncode(payload),
        status: const Value('pending'),
        userId: Value(_currentUserId),
        createdAt: DateTime.now(),
      ),
    );

    await _outbox.enqueue(
      role: 'orderBooker',
      action: 'register_shop',
      payload: payload,
      entityType: 'shop',
      localEntityId: localShopId,
    );

    final row = await _db.localShopById(localShopId, userId: _currentUserId);
    return localShopToModel(row!);
  }

  void clearSessionMemory() => _shopDetailMemory.clear();

  String? get _currentUserId {
    if (!Get.isRegistered<SessionService>()) return null;
    final id = Get.find<SessionService>().user.value?.id;
    return (id == null || id.isEmpty) ? null : id;
  }

  /// Submits shop setup for a `not_visited` shop and opens the visit.
  ///
  /// Online this is a single `shops/verify-on-site` call. Offline the photos
  /// and fields are queued and the visit is opened locally right away.
  Future<ObVerifySubmitResult> submitVerification({
    required ObTaskModel task,
    required int shopId,
    required double latitude,
    required double longitude,
    required Map<String, Uint8List> photos,
    Map<String, dynamic> fields = const {},
  }) async {
    if (_canReachServer) {
      try {
        final data = await _api.postData(
          ApiEndpoints.obShopsVerifyOnSite,
          data: {
            'shop_id': shopId,
            'task_id': task.id,
            'latitude': latitude,
            'longitude': longitude,
            ...fields,
            for (final photo in photos.entries)
              photo.key: base64Encode(photo.value),
          },
        );
        final result = ObCheckInResult.fromJson(data);
        _shopDetailMemory.remove('$shopId');
        await _cache.clearKeys([OfflineCacheKeys.shopDetail('$shopId')]);

        if (result.hasVisit) {
          await _session?.adoptServerVisit(
            task: task,
            visit: result.visit!,
            latitude: latitude,
            longitude: longitude,
          );
          await _session?.setTaskVerified(task.id);
        }
        return ObVerifySubmitResult(
          queued: false,
          visit: result.visit,
          message: result.message,
        );
      } on ApiException catch (e) {
        if (!_isTransient(e.message)) rethrow;
      }
    }

    final session = _session;
    if (session == null) {
      throw ApiException(message: 'Offline verification is unavailable.');
    }
    final visit = await session.startVerifiedVisit(
      task: task,
      latitude: latitude,
      longitude: longitude,
      shopId: shopId,
      photos: photos,
      fields: fields,
    );
    return ObVerifySubmitResult(queued: true, visit: visit);
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
