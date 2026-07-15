import 'dart:convert';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

/// Disk keys for last-successful Order Booker list payloads.
abstract class OfflineCacheKeys {
  static const shopsMine = 'offline_cache_ob_shops_mine';
  static const tasksToday = 'offline_cache_ob_tasks_today';
  static const activeVisit = 'offline_cache_ob_visits_active';
  static const targetsMine = 'offline_cache_ob_targets_mine';
  static const scheduleWeekly = 'offline_cache_ob_schedule_weekly';
  static const visitsMine = 'offline_cache_ob_visits_mine';
  static const dashboard = 'offline_cache_ob_dashboard';
  static const zones = 'offline_cache_ob_zones';

  static String routes(int? zoneId) =>
      'offline_cache_ob_routes_${zoneId ?? 'all'}';
}

/// Persists JSON maps so list screens stay usable after offline restart.
class OfflineCacheService extends GetxService {
  OfflineCacheService(this._storage);

  final StorageService _storage;

  Future<void> saveMap(String key, Map<String, dynamic> data) async {
    await _storage.writeValue(key, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> readMap(String key) async {
    final raw = await _storage.readValue(key);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  /// Fetches, saves, and parses. On failure, returns last saved payload if any.
  Future<T> readThrough<T>({
    required String key,
    required Future<Map<String, dynamic>> Function() fetch,
    required T Function(Map<String, dynamic> json) parse,
    bool persist = true,
  }) async {
    try {
      final data = await fetch();
      if (persist) await saveMap(key, data);
      return parse(data);
    } catch (_) {
      final cached = await readMap(key);
      if (cached != null) return parse(cached);
      rethrow;
    }
  }
}
