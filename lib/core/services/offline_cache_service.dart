import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/services/app_cache_storage.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

/// Disk keys for last-successful payloads and the app-wide sync queue.
/// Shared by all roles (OB / DM) — do not split into role-specific services.
abstract class OfflineCacheKeys {
  // Order Booker
  static const shopsMine = 'offline_cache_ob_shops_mine';
  static const tasksToday = 'offline_cache_ob_tasks_today';
  static const activeVisit = 'offline_cache_ob_visits_active';
  static const targetsMine = 'offline_cache_ob_targets_mine';
  static const scheduleWeekly = 'offline_cache_ob_schedule_weekly';
  static const visitsMine = 'offline_cache_ob_visits_mine';
  static const dashboard = 'offline_cache_ob_dashboard';
  static const zones = 'offline_cache_ob_zones';
  static const shopDetailPrefix = 'offline_cache_ob_shop_detail_';

  static String routes(int? zoneId) =>
      'offline_cache_ob_routes_${zoneId ?? 'all'}';

  static String shopDetail(String id) => '$shopDetailPrefix$id';

  /// Keys wiped on OB logout so a new session cannot show a previous route.
  static const List<String> orderBookerSessionKeys = [
    shopsMine,
    tasksToday,
    activeVisit,
    targetsMine,
    scheduleWeekly,
    visitsMine,
    dashboard,
    zones,
  ];

  // Delivery Man — deliveries
  static const dmOrders = 'offline_cache_dm_orders_v2';
  static const dmPickup = 'offline_cache_dm_pickup_v2';
  static const dmReturn = 'offline_cache_dm_return_v2';
  static const dmVanStock = 'offline_cache_dm_van_stock_v1';

  // Delivery Man — collections / handover
  static const dmShops = 'offline_cache_dm_shops_v1';
  static const dmInvoices = 'offline_cache_dm_invoices_v1';
  static const dmCollections = 'offline_cache_dm_collections_v1';
  static const dmHandovers = 'offline_cache_dm_handovers_v1';
  static const dmCollectionTargets = 'offline_cache_dm_collection_targets_v1';

  /// Pending mutation queue for every role (legacy JSON; drift outbox is primary).
  static const syncQueue = 'offline_cache_sync_queue';
}

/// One queued mutation waiting to sync when the device is online.
class OfflineSyncItem {
  const OfflineSyncItem({
    required this.id,
    required this.role,
    required this.action,
    required this.payload,
    required this.createdAt,
    this.synced = false,
  });

  final String id;
  final String role;
  final String action;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final bool synced;

  OfflineSyncItem copyWith({bool? synced}) => OfflineSyncItem(
    id: id,
    role: role,
    action: action,
    payload: payload,
    createdAt: createdAt,
    synced: synced ?? this.synced,
  );

  factory OfflineSyncItem.fromJson(Map<String, dynamic> json) {
    final payloadRaw = json['payload'];
    return OfflineSyncItem(
      id: json['id']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      payload: payloadRaw is Map
          ? Map<String, dynamic>.from(payloadRaw)
          : const <String, dynamic>{},
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      synced: json['synced'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'action': action,
    'payload': payload,
    'created_at': createdAt.toUtc().toIso8601String(),
    'synced': synced,
  };
}

typedef OfflineSyncHandler = Future<void> Function(OfflineSyncItem item);

/// Persists JSON maps so screens stay usable after offline restart.
class OfflineCacheService extends GetxService {
  OfflineCacheService(this._storage, this._cache);

  final StorageService _storage;
  final AppCacheStorage _cache;
  final Map<String, OfflineSyncHandler> _handlers = {};
  final RxInt pendingSyncCount = 0.obs;
  final RxMap<String, DateTime?> cacheUpdatedAt = <String, DateTime?>{}.obs;
  final RxBool isRefreshingCache = false.obs;
  bool _flushing = false;
  final Set<String> _backgroundRefreshKeys = {};

  static const _defaultTtl = Duration(minutes: 15);

  Future<void> saveMap(String key, Map<String, dynamic> data) async {
    await _cache.saveMap(key, data);
    cacheUpdatedAt[key] = DateTime.now();
  }

  Future<Map<String, dynamic>?> readMap(String key) async {
    await _migrateLegacyIfNeeded(key);
    return _cache.readMap(key);
  }

  Future<void> saveList(String key, List<Map<String, dynamic>> items) async {
    await saveMap(key, {'items': items});
  }

  Future<List<Map<String, dynamic>>> readList(String key) async {
    final map = await readMap(key);
    if (map == null) return const [];
    final raw = map['items'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
  }

  /// Cache-first: return saved data immediately, refresh in background when online.
  Future<T> readThrough<T>({
    required String key,
    required Future<Map<String, dynamic>> Function() fetch,
    required T Function(Map<String, dynamic> json) parse,
    bool persist = true,
    bool allowStaleFallback = true,
    bool cacheFirst = true,
    Duration? ttl,
  }) async {
    await _migrateLegacyIfNeeded(key);
    final updatedAt = await _cache.readUpdatedAt(key);
    cacheUpdatedAt[key] = updatedAt;
    final cached = await _cache.readMap(key);
    final effectiveTtl = ttl ?? _defaultTtl;
    final isFresh =
        updatedAt != null &&
        DateTime.now().difference(updatedAt) < effectiveTtl;
    final shouldDefer = _shouldDeferBackgroundRefresh();

    if (cacheFirst && cached != null && !shouldDefer) {
      final parsed = parse(cached);
      if (!isFresh &&
          allowStaleFallback &&
          !_backgroundRefreshKeys.contains(key)) {
        unawaited(
          _refreshInBackground(
            key: key,
            fetch: fetch,
            parse: parse,
            persist: persist,
            allowStaleFallback: allowStaleFallback,
          ),
        );
      }
      return parsed;
    }

    if (cacheFirst && cached != null && shouldDefer) {
      return parse(cached);
    }

    try {
      final data = await fetch();
      if (persist) await saveMap(key, data);
      return parse(data);
    } catch (_) {
      if (!allowStaleFallback) rethrow;
      if (cached != null) return parse(cached);
      rethrow;
    }
  }

  Future<void> _refreshInBackground<T>({
    required String key,
    required Future<Map<String, dynamic>> Function() fetch,
    required T Function(Map<String, dynamic> json) parse,
    required bool persist,
    required bool allowStaleFallback,
  }) async {
    if (_backgroundRefreshKeys.contains(key) ||
        _shouldDeferBackgroundRefresh()) {
      return;
    }
    _backgroundRefreshKeys.add(key);
    isRefreshingCache.value = true;
    try {
      final data = await fetch();
      if (persist) await saveMap(key, data);
    } catch (_) {
      // Keep stale cache silently.
    } finally {
      _backgroundRefreshKeys.remove(key);
      isRefreshingCache.value = _backgroundRefreshKeys.isNotEmpty;
    }
  }

  bool _shouldDeferBackgroundRefresh() {
    if (!Get.isRegistered<ConnectivityService>()) return false;
    final connectivity = Get.find<ConnectivityService>();
    if (!connectivity.isOnline.value) return true;
    return connectivity.quality.value == NetworkQuality.weak;
  }

  /// Use disk cache first only when offline or on a weak link.
  bool shouldServeCacheFirst() {
    if (!Get.isRegistered<ConnectivityService>()) return false;
    final connectivity = Get.find<ConnectivityService>();
    if (!connectivity.isOnline.value) return true;
    return connectivity.quality.value == NetworkQuality.weak;
  }

  /// Whether [readThrough] should return disk cache before hitting the network.
  bool cacheFirstFor({
    bool allowStaleFallback = true,
    bool forceNetwork = false,
  }) {
    if (forceNetwork) return false;
    if (!allowStaleFallback) return false;
    return shouldServeCacheFirst();
  }

  Future<void> _migrateLegacyIfNeeded(String key) async {
    await _cache.importFromSecureStorage(
      key: key,
      readLegacy: () => _storage.readValue(key),
    );
  }

  Future<void> clearKeys(Iterable<String> keys) async {
    await _cache.clearKeys(keys);
    for (final key in keys) {
      cacheUpdatedAt.remove(key);
    }
  }

  Future<void> clearOrderBookerSessionCache() async {
    await clearKeys(OfflineCacheKeys.orderBookerSessionKeys);
    final all = await _storage.readAllValues();
    final dynamicKeys = all.keys.where(
      (key) =>
          key.startsWith('offline_cache_ob_routes_') ||
          key.startsWith(OfflineCacheKeys.shopDetailPrefix),
    );
    if (dynamicKeys.isNotEmpty) {
      await clearKeys(dynamicKeys);
    }
  }

  void registerSyncHandler(
    String role,
    String action,
    OfflineSyncHandler handler,
  ) {
    _handlers['$role.$action'] = handler;
  }

  Future<List<OfflineSyncItem>> readSyncQueue() async {
    final raw = await readList(OfflineCacheKeys.syncQueue);
    return raw.map(OfflineSyncItem.fromJson).toList(growable: false);
  }

  Future<void> _writeSyncQueue(List<OfflineSyncItem> items) async {
    await saveList(
      OfflineCacheKeys.syncQueue,
      items.map((e) => e.toJson()).toList(growable: false),
    );
    pendingSyncCount.value = items.where((e) => !e.synced).length;
  }

  Future<void> refreshPendingSyncCount() async {
    final items = await readSyncQueue();
    pendingSyncCount.value = items.where((e) => !e.synced).length;
  }

  Future<OfflineSyncItem> enqueueSync({
    required String role,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final items = List<OfflineSyncItem>.from(await readSyncQueue());
    final item = OfflineSyncItem(
      id: 'sync-${DateTime.now().millisecondsSinceEpoch}-${items.length}',
      role: role,
      action: action,
      payload: payload,
      createdAt: DateTime.now(),
    );
    items.add(item);
    await _writeSyncQueue(items);
    return item;
  }

  Future<void> flushSyncQueue() async {
    if (_flushing) return;
    _flushing = true;
    try {
      final items = List<OfflineSyncItem>.from(await readSyncQueue());
      var changed = false;
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        if (item.synced) continue;
        final handler = _handlers['${item.role}.${item.action}'];
        if (handler == null) {
          items[i] = item.copyWith(synced: false);
          changed = true;
          continue;
        }
        try {
          await handler(item);
          items[i] = item.copyWith(synced: true);
          changed = true;
        } catch (_) {
          break;
        }
      }
      if (changed) {
        final remaining = items.where((e) => !e.synced).toList(growable: false);
        await _writeSyncQueue(remaining);
      }
    } finally {
      _flushing = false;
    }
  }

  DateTime? updatedAtFor(String key) => cacheUpdatedAt[key];

  bool isStale(String key, {Duration? ttl}) {
    final at = cacheUpdatedAt[key];
    if (at == null) return true;
    return DateTime.now().difference(at) > (ttl ?? _defaultTtl);
  }
}
