import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:get/get.dart' hide Value;

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/dashboard/ob_dashboard_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/shops/ob_shop_service.dart';

/// Catalog scopes. Prices are uniform across shops, so one global catalog is
/// correct for every visit; the scope key keeps per-shop catalogs possible.
abstract class ObDayCatalog {
  static const globalScope = 'global';
}

/// Drift keys for snapshots that have no JSON cache of their own.
abstract class ObDocKeys {
  static const visitHistoryWindow = 'ob_visit_history_window';

  static String visitDetail(int visitId) => 'ob_visit_detail_$visitId';

  static String orderDetail(int visitId) => 'ob_order_detail_$visitId';

  /// Stored as order_number until the server assigns a real SO number.
  static const pendingSyncOrderMarker = 'PENDING_SYNC';
}

/// Pulls a full day of data into local storage so the rest of the day needs no
/// connectivity at all.
///
/// Runs in the background: screens stay usable from the previous snapshot while
/// this refreshes underneath them. Every section is independent, so a partial
/// run still improves what is available offline.
class ObDayBootstrapService extends GetxService {
  ObDayBootstrapService(this._api, this._db);

  final ApiClient _api;
  final AppDatabase _db;

  final RxBool isRunning = false.obs;
  final Rxn<DateTime> lastCompletedAt = Rxn<DateTime>();
  final RxnString lastError = RxnString();
  final RxnString statusMessage = RxnString();
  final RxBool catalogReady = false.obs;

  /// Newest visit count kept for offline History (list + detail prefetch).
  static const historyVisitLimit = 10;
  static const _minInterval = Duration(minutes: 10);

  DateTime? _lastAttemptAt;

  OfflineCacheService get _cache => Get.find<OfflineCacheService>();

  bool get _canReachServer {
    if (!Get.isRegistered<ConnectivityService>()) return true;
    final connectivity = Get.find<ConnectivityService>();
    if (!connectivity.isOnline.value) return false;
    return connectivity.quality.value != NetworkQuality.weak;
  }

  /// When the day snapshot was last written, used for the "Data as of" strip.
  DateTime? get snapshotUpdatedAt =>
      _cache.updatedAtFor(OfflineCacheKeys.tasksToday) ?? lastCompletedAt.value;

  /// True when the snapshot predates today and needs a refresh to be trusted.
  bool get isSnapshotStale {
    final at = snapshotUpdatedAt;
    if (at == null) return true;
    final now = DateTime.now();
    return at.isBefore(DateTime(now.year, now.month, now.day));
  }

  @override
  void onInit() {
    super.onInit();
    unawaited(refreshCatalogReady());
  }

  Future<void> refreshCatalogReady() async {
    final rows = await _db.catalogFor(ObDayCatalog.globalScope);
    catalogReady.value = rows.isNotEmpty;
  }

  /// Fire-and-forget refresh used on app open, reconnect and pull-to-refresh.
  void runInBackground({bool force = false}) {
    unawaited(run(force: force));
  }

  Future<void> run({bool force = false}) async {
    if (isRunning.value) return;
    if (!_canReachServer) return;

    final last = _lastAttemptAt;
    if (!force &&
        last != null &&
        DateTime.now().difference(last) < _minInterval) {
      return;
    }
    _lastAttemptAt = DateTime.now();

    isRunning.value = true;
    lastError.value = null;
    var failures = 0;

    // Catalog early: offline ordering depends on it more than history/targets.
    failures += await _step(AppTexts.obDayBootstrapTasks, _loadToday);
    failures += await _step(
      AppTexts.obDayBootstrapActiveVisit,
      _loadActiveVisit,
    );
    failures += await _step(AppTexts.obDayBootstrapCatalog, _loadCatalog);
    failures += await _step(AppTexts.obDayBootstrapShops, _loadShops);
    failures += await _step(AppTexts.obDayBootstrapRoutes, _loadZonesAndRoutes);
    failures += await _step(AppTexts.obDayBootstrapSchedule, _loadSchedule);
    failures += await _step(AppTexts.obDayBootstrapTargets, _loadTargets);
    failures += await _step(AppTexts.obDayBootstrapHistory, _loadVisitHistory);
    failures += await _step(AppTexts.obDayBootstrapDashboard, _loadDashboard);

    isRunning.value = false;
    statusMessage.value = null;
    await refreshCatalogReady();
    if (failures == 0) {
      lastCompletedAt.value = DateTime.now();
    }
  }

  Future<int> _step(String label, Future<void> Function() action) async {
    statusMessage.value = label;
    try {
      await action();
      return 0;
    } catch (error) {
      lastError.value = error.toString();
      return 1;
    }
  }

  Future<void> _loadToday() async {
    final data = await _api.postData(ApiEndpoints.obTasksToday);
    await _cache.saveMap(OfflineCacheKeys.tasksToday, data);
  }

  Future<void> _loadActiveVisit() async {
    final data = await _api.postData(ApiEndpoints.obVisitsActive);
    await _cache.saveMap(OfflineCacheKeys.activeVisit, data);
  }

  Future<void> _loadShops() async {
    final data = await _api.postData(ApiEndpoints.obShopsMine);
    await _cache.saveMap(OfflineCacheKeys.shopsMine, data);

    // Prefer the shop service so photos land in MediaFiles for offline.
    if (Get.isRegistered<ObShopService>()) {
      final shopService = Get.find<ObShopService>();
      for (final shop in ApiMap.listOf(data, 'shops')) {
        final id = ApiMap.asInt(shop['shop_id']) ?? ApiMap.asInt(shop['id']);
        if (id == null) continue;
        try {
          await shopService.fetchShop('$id', includePhotos: true, force: true);
        } catch (_) {
          // Keep going; the list entry still covers the basics.
        }
      }
      return;
    }

    for (final shop in ApiMap.listOf(data, 'shops')) {
      final id = ApiMap.asInt(shop['shop_id']) ?? ApiMap.asInt(shop['id']);
      if (id == null) continue;
      try {
        final detail = await _api.postData(
          ApiEndpoints.obShopsGet,
          data: {'shop_id': id, 'include_photos': true},
        );
        final shopJson = ApiMap.asMap(detail['shop']) ?? detail;
        await _cache.saveMap(OfflineCacheKeys.shopDetail('$id'), shopJson);
      } catch (_) {
        // Keep going; the list entry still covers the basics.
      }
    }
  }

  Future<void> _loadVisitHistory() async {
    // Keep offline History light: only the newest N list rows + details.
    final recent = await _api.postData(
      ApiEndpoints.obVisitsMine,
      data: {'limit': historyVisitLimit, 'offset': 0},
    );
    await _cache.saveMap(OfflineCacheKeys.visitsMine, recent);
    await _db.saveDoc(ObDocKeys.visitHistoryWindow, jsonEncode(recent));

    // Prefetch visit details so History opens offline without "not found".
    final visits = ApiMap.listOf(recent, 'visits');
    var fetched = 0;
    for (final row in visits) {
      final id = ApiMap.asInt(row['visit_id']) ?? ApiMap.asInt(row['id']);
      if (id == null || id <= 0) continue;

      // Always keep at least the list payload as a stub detail.
      final existing = await _db.readDoc(ObDocKeys.visitDetail(id));
      if (existing == null) {
        await _db.saveDoc(ObDocKeys.visitDetail(id), jsonEncode(row));
        await _db.saveDoc(ObDocKeys.orderDetail(id), jsonEncode(row));
      }

      // Full visits/get for each of the newest N (lines + approval).
      if (fetched >= historyVisitLimit) continue;
      try {
        final data = await _api.postData(
          ApiEndpoints.obVisitsGet,
          data: {'visit_id': id},
        );
        final visitJson = ApiMap.asMap(data['visit']) ?? data;
        final encoded = jsonEncode(visitJson);
        await _db.saveDoc(ObDocKeys.visitDetail(id), encoded);
        await _db.saveDoc(ObDocKeys.orderDetail(id), encoded);
        fetched++;
      } catch (_) {
        // Stub from list row remains.
      }
    }
  }

  Future<void> _loadZonesAndRoutes() async {
    final zones = await _api.postData(ApiEndpoints.obZonesList);
    await _cache.saveMap(OfflineCacheKeys.zones, zones);

    final all = await _api.postData(ApiEndpoints.obRoutesList);
    await _cache.saveMap(OfflineCacheKeys.routes(null), all);

    for (final zone in ApiMap.listOf(zones, 'zones')) {
      final zoneId = ApiMap.asInt(zone['id']) ?? ApiMap.asInt(zone['zone_id']);
      if (zoneId == null) continue;
      try {
        final routes = await _api.postData(
          ApiEndpoints.obRoutesList,
          data: {'zone_id': zoneId},
        );
        await _cache.saveMap(OfflineCacheKeys.routes(zoneId), routes);
      } catch (_) {
        // A missing zone's routes should not stop the others.
      }
    }
  }

  Future<void> _loadSchedule() async {
    final data = await _api.postData(ApiEndpoints.obScheduleWeekly);
    await _cache.saveMap(OfflineCacheKeys.scheduleWeekly, data);
  }

  Future<void> _loadTargets() async {
    final data = await _api.postData(ApiEndpoints.obTargetsMine);
    await _cache.saveMap(OfflineCacheKeys.targetsMine, data);
  }

  Future<void> _loadDashboard() async {
    final today = await _cache.readMap(OfflineCacheKeys.tasksToday);
    final targets = await _cache.readMap(OfflineCacheKeys.targetsMine);
    final visits = await _cache.readMap(OfflineCacheKeys.visitsMine);
    if (today == null || targets == null || visits == null) {
      throw StateError('Day snapshot pieces missing for dashboard cache.');
    }
    final dashboard = ObDashboardService.composeSnapshot(
      todayJson: today,
      targetsJson: targets,
      visitsJson: visits,
    );
    await _cache.saveMap(OfflineCacheKeys.dashboard, dashboard.toJson());
  }

  /// Catalog for offline ordering. `visit_id` is optional on the API.
  Future<void> _loadCatalog() async {
    final visitId = await _anyUsableVisitId();
    final data = await _api.postData(
      ApiEndpoints.obProductsList,
      data: {'visit_id': ?visitId, 'limit': 500, 'offset': 0},
    );
    final products = ApiMap.listOf(data, 'products');
    if (products.isEmpty) {
      throw StateError('Product catalog response was empty.');
    }
    await saveGlobalCatalog(products);
  }

  Future<void> saveGlobalCatalog(List<Map<String, dynamic>> products) async {
    final now = DateTime.now();
    await _db.replaceCatalog(
      ObDayCatalog.globalScope,
      products
          .map((product) {
            final id =
                ApiMap.asInt(product['product_id']) ??
                ApiMap.asInt(product['id']);
            if (id == null) return null;
            return CatalogProductsCompanion.insert(
              scope: const Value(ObDayCatalog.globalScope),
              productId: id,
              jsonPayload: jsonEncode(product),
              updatedAt: now,
            );
          })
          .whereType<CatalogProductsCompanion>()
          .toList(growable: false),
    );
    catalogReady.value = products.isNotEmpty;
  }

  Future<int?> _anyUsableVisitId() async {
    final fromActive = _visitIdFromActive(
      await _cache.readMap(OfflineCacheKeys.activeVisit),
    );
    if (fromActive != null) return fromActive;

    final fromMine = _firstVisitId(
      await _cache.readMap(OfflineCacheKeys.visitsMine),
    );
    if (fromMine != null) return fromMine;

    final historyDoc = await _db.readDoc(ObDocKeys.visitHistoryWindow);
    if (historyDoc != null) {
      try {
        final decoded = jsonDecode(historyDoc.jsonPayload);
        if (decoded is Map<String, dynamic>) {
          final fromWindow = _firstVisitId(decoded);
          if (fromWindow != null) return fromWindow;
        }
      } catch (_) {
        // Fall through to live lookups.
      }
    }

    try {
      final active = await _api.postData(ApiEndpoints.obVisitsActive);
      final id = _visitIdFromActive(active);
      if (id != null) return id;
    } catch (_) {
      // Fall through to the visit list.
    }

    try {
      final data = await _api.postData(
        ApiEndpoints.obVisitsMine,
        data: {'limit': 1, 'offset': 0},
      );
      return _firstVisitId(data);
    } catch (_) {
      return null;
    }
  }

  static int? _visitIdFromActive(Map<String, dynamic>? data) {
    if (data == null) return null;
    final visit = ApiMap.asMap(data['visit']) ?? data;
    final id = ApiMap.asInt(visit['visit_id']) ?? ApiMap.asInt(visit['id']);
    if (id == null || id <= 0) return null;
    return id;
  }

  static int? _firstVisitId(Map<String, dynamic>? data) {
    if (data == null) return null;
    for (final row in ApiMap.listOf(data, 'visits')) {
      final id = ApiMap.asInt(row['visit_id']) ?? ApiMap.asInt(row['id']);
      if (id != null && id > 0) return id;
    }
    return null;
  }
}
