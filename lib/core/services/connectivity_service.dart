import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/sync/dm_day_bootstrap_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/dashboard/ob_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/shops/ob_my_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/tasks/ob_route_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/sync/ob_day_bootstrap_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_session_service.dart';

enum NetworkQuality { offline, weak, medium, good }

class ConnectivityService extends GetxService {
  final RxBool isOnline = true.obs;
  final Rx<NetworkQuality> quality = NetworkQuality.good.obs;

  final Connectivity _connectivity = Connectivity();
  final Dio _probe = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
      sendTimeout: const Duration(seconds: 6),
      followRedirects: false,
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  bool _wasOffline = false;
  bool _listening = false;
  bool _probing = false;
  bool _syncPassRunning = false;
  Timer? _probeTimer;

  static const _probeUrl = 'https://connectivitycheck.gstatic.com/generate_204';
  static const _weakMs = 800;
  static const _mediumMs = 300;

  Future<ConnectivityService> init() async {
    if (_listening) return this;
    _listening = true;

    try {
      final result = await _connectivity.checkConnectivity();
      isOnline.value = _hasConnection(result);
      if (!isOnline.value) {
        _wasOffline = true;
        quality.value = NetworkQuality.offline;
      }
    } catch (_) {
      // Keep default; listener will correct state.
    }

    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    // Day bootstrap is owned by OB shell (login) and reconnect / pending
    // rules below — not on every ConnectivityService init.
    if (_canProbeQuality) {
      unawaited(_probeQuality());
      _probeTimer = Timer.periodic(
        const Duration(seconds: 12),
        (_) => unawaited(_probeQuality()),
      );
    } else if (isOnline.value) {
      quality.value = NetworkQuality.good;
    }
    return this;
  }

  bool get _canProbeQuality => !kIsWeb && Platform.isAndroid;

  bool get _isReadyToSync =>
      isOnline.value &&
      (quality.value == NetworkQuality.medium ||
          quality.value == NetworkQuality.good);

  bool get _hasPendingSync {
    var pending = false;
    if (Get.isRegistered<SyncOutboxService>()) {
      final outbox = Get.find<SyncOutboxService>();
      pending =
          outbox.pendingCount.value > 0 || outbox.attentionCount.value > 0;
    }
    if (!pending && Get.isRegistered<OfflineCacheService>()) {
      pending = Get.find<OfflineCacheService>().pendingSyncCount.value > 0;
    }
    return pending;
  }

  /// Push outbox, optionally pull day snapshot afterward. Never parallel.
  Future<void> _syncPass({required bool pullDay}) async {
    if (!_isReadyToSync || _syncPassRunning) return;
    _syncPassRunning = true;
    try {
      if (Get.isRegistered<OfflineCacheService>()) {
        await Get.find<OfflineCacheService>().flushSyncQueue();
      }
      if (Get.isRegistered<SyncOutboxService>()) {
        await Get.find<SyncOutboxService>().flush(force: true);
      }
      if (!pullDay) return;

      if (Get.isRegistered<ObDayBootstrapService>()) {
        await Get.find<ObDayBootstrapService>().run(force: true);
      }
      if (Get.isRegistered<ObVisitSessionService>()) {
        await Get.find<ObVisitSessionService>().refreshLocalVisitIndex();
      }
      if (Get.isRegistered<ObRouteDetailController>()) {
        await Get.find<ObRouteDetailController>().loadTasks(
          silent: true,
          force: true,
        );
      }
      if (Get.isRegistered<ObDashboardController>()) {
        await Get.find<ObDashboardController>().loadDashboard(force: true);
      }
      if (Get.isRegistered<ObMyShopsController>()) {
        await Get.find<ObMyShopsController>().loadShops(force: true);
      }
    } catch (_) {
      // Screens keep last known data; next reconnect retries.
    } finally {
      _syncPassRunning = false;
    }
    if (Get.isRegistered<DmDayBootstrapService>()) {
      Get.find<DmDayBootstrapService>().runInBackground();
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) {
    final online = _hasConnection(result);
    final wasOnline = isOnline.value;
    isOnline.value = online;

    if (!online) {
      _wasOffline = true;
      quality.value = NetworkQuality.offline;
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      return;
    }

    final cameOnline = _wasOffline || !wasOnline;
    if (cameOnline) {
      _wasOffline = false;
      AppToast.showSuccess(AppTexts.backOnline);
    }

    if (_canProbeQuality) {
      unawaited(_probeQuality(cameOnline: cameOnline));
      return;
    }

    quality.value = NetworkQuality.good;
    if (cameOnline) {
      unawaited(_syncPass(pullDay: true));
    } else if (_hasPendingSync) {
      unawaited(_syncPass(pullDay: true));
    }
  }

  Future<void> _probeQuality({bool cameOnline = false}) async {
    if (!_canProbeQuality || _probing) return;
    if (!isOnline.value) {
      quality.value = NetworkQuality.offline;
      return;
    }

    _probing = true;
    final previous = quality.value;
    final stopwatch = Stopwatch()..start();
    try {
      await _probe.get<void>(_probeUrl);
      stopwatch.stop();
      final ms = stopwatch.elapsedMilliseconds;
      quality.value = ms >= _weakMs
          ? NetworkQuality.weak
          : ms >= _mediumMs
          ? NetworkQuality.medium
          : NetworkQuality.good;
    } catch (_) {
      if (isOnline.value) quality.value = NetworkQuality.weak;
    } finally {
      _probing = false;
    }

    if (!_isReadyToSync) return;

    // Offline → ready: always flush then day pull.
    if (cameOnline || previous == NetworkQuality.offline) {
      unawaited(_syncPass(pullDay: true));
      return;
    }

    // Weak → medium/good: only when there is pending work.
    if (previous == NetworkQuality.weak && _hasPendingSync) {
      unawaited(_syncPass(pullDay: true));
    }
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  void ensureOnline() {
    if (!isOnline.value) {
      throw ApiException(message: AppTexts.noInternet);
    }
  }

  @override
  void onClose() {
    _probeTimer?.cancel();
    _probe.close();
    super.onClose();
  }
}
