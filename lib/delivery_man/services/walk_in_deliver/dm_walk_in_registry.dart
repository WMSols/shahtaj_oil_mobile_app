import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';

/// Remembers walk-in job / payment / shop ids so UI can show the Walk-in chip
/// even when plan/collections payloads omit an explicit flag.
class DmWalkInRegistry extends GetxService {
  DmWalkInRegistry({OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final OfflineCacheService _cache;

  final RxSet<int> jobIds = <int>{}.obs;
  final RxSet<int> paymentIds = <int>{}.obs;
  final RxSet<String> shopIds = <String>{}.obs;

  bool get isReady => _hydrated;
  bool _hydrated = false;

  Future<void> hydrate() async {
    if (_hydrated) return;
    final map = await _cache.readMap(OfflineCacheKeys.dmWalkInIds);
    if (map != null) {
      jobIds
        ..clear()
        ..addAll(_ints(map['job_ids']));
      paymentIds
        ..clear()
        ..addAll(_ints(map['payment_ids']));
      shopIds
        ..clear()
        ..addAll(_strings(map['shop_ids']));
    }
    _hydrated = true;
  }

  bool isWalkInJob(int jobId) => jobId > 0 && jobIds.contains(jobId);

  bool isWalkInPayment(int paymentId) =>
      paymentId > 0 && paymentIds.contains(paymentId);

  bool isWalkInShop(String shopId) {
    final id = shopId.trim();
    return id.isNotEmpty && shopIds.contains(id);
  }

  Future<void> remember({int? jobId, int? paymentId, String? shopId}) async {
    await hydrate();
    var changed = false;
    if (jobId != null && jobId > 0 && jobIds.add(jobId)) changed = true;
    if (paymentId != null && paymentId > 0 && paymentIds.add(paymentId)) {
      changed = true;
    }
    final shop = shopId?.trim() ?? '';
    if (shop.isNotEmpty && shopIds.add(shop)) changed = true;
    if (changed) await _persist();
  }

  Future<void> _persist() async {
    await _cache.saveMap(OfflineCacheKeys.dmWalkInIds, {
      'job_ids': jobIds.toList(growable: false),
      'payment_ids': paymentIds.toList(growable: false),
      'shop_ids': shopIds.toList(growable: false),
    });
  }

  static Set<int> _ints(dynamic raw) {
    if (raw is! List) return {};
    return {
      for (final item in raw)
        if ((ApiMap.asInt(item) ?? 0) > 0) ApiMap.asInt(item)!,
    };
  }

  static Set<String> _strings(dynamic raw) {
    if (raw is! List) return {};
    return {
      for (final item in raw)
        if ((ApiMap.asString(item) ?? '').isNotEmpty) ApiMap.asString(item)!,
    };
  }
}
