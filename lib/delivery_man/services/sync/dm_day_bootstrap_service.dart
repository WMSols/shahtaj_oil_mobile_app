import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/load/dm_load_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/session/dm_session_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';

/// Prefetches today's DM session / load / plan / van into offline cache so
/// leaves can render after a brief online window (OB-style day snapshot).
///
/// Field mutations (deliver / free deliver) stay online-only.
class DmDayBootstrapService extends GetxService {
  final RxBool isRunning = false.obs;
  final Rxn<DateTime> lastCompletedAt = Rxn<DateTime>();
  final RxnString lastError = RxnString();

  static const _minInterval = Duration(minutes: 10);

  DateTime? _lastAttemptAt;

  OfflineCacheService get _cache => Get.find<OfflineCacheService>();

  bool get _canReachServer {
    if (!Get.isRegistered<ConnectivityService>()) return true;
    final connectivity = Get.find<ConnectivityService>();
    if (!connectivity.isOnline.value) return false;
    return connectivity.quality.value != NetworkQuality.weak;
  }

  /// Newest of the live DM snapshot timestamps (for "Data as of").
  DateTime? get snapshotUpdatedAt {
    final stamps = <DateTime?>[
      _cache.updatedAtFor(OfflineCacheKeys.dmSession),
      _cache.updatedAtFor(OfflineCacheKeys.dmLoadToday),
      _cache.updatedAtFor(OfflineCacheKeys.dmPlanToday),
      _cache.updatedAtFor(OfflineCacheKeys.dmVanSnapshot),
      _cache.updatedAtFor(OfflineCacheKeys.dmWallet),
      lastCompletedAt.value,
    ].whereType<DateTime>();
    if (stamps.isEmpty) return null;
    return stamps.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  bool get isSnapshotStale {
    final at = snapshotUpdatedAt;
    if (at == null) return true;
    final now = DateTime.now();
    return at.isBefore(DateTime(now.year, now.month, now.day));
  }

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

    failures += await _step(() async {
      if (!Get.isRegistered<DmSessionService>()) return;
      await Get.find<DmSessionService>().fetchSession(forceNetwork: true);
    });
    failures += await _step(() async {
      if (!Get.isRegistered<DmLoadService>()) return;
      await Get.find<DmLoadService>().fetchToday(forceNetwork: true);
    });
    failures += await _step(() async {
      if (!Get.isRegistered<DmPlanService>()) return;
      await Get.find<DmPlanService>().fetchToday(forceNetwork: true);
    });
    failures += await _step(() async {
      if (!Get.isRegistered<DmVanService>()) return;
      await Get.find<DmVanService>().fetchSnapshot(forceNetwork: true);
    });
    failures += await _step(() async {
      if (!Get.isRegistered<DmRecoveryService>()) return;
      await Get.find<DmRecoveryService>().fetchWallet(forceNetwork: true);
    });

    isRunning.value = false;
    if (failures == 0) {
      lastCompletedAt.value = DateTime.now();
    }
  }

  Future<int> _step(Future<void> Function() action) async {
    try {
      await action();
      return 0;
    } catch (error) {
      lastError.value = error.toString();
      return 1;
    }
  }
}
