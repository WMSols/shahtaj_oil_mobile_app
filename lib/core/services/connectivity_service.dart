import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

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
    if (isOnline.value && Get.isRegistered<OfflineCacheService>()) {
      unawaited(Get.find<OfflineCacheService>().flushSyncQueue());
    }
    if (_canProbeQuality) {
      unawaited(_probeQuality());
      _probeTimer = Timer.periodic(
        const Duration(seconds: 12),
        (_) => unawaited(_probeQuality()),
      );
    }
    return this;
  }

  bool get _canProbeQuality => !kIsWeb && Platform.isAndroid;

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

    if (_wasOffline || !wasOnline) {
      _wasOffline = false;
      AppToast.showSuccess(AppTexts.backOnline);
      if (Get.isRegistered<OfflineCacheService>()) {
        unawaited(Get.find<OfflineCacheService>().flushSyncQueue());
      }
    }
    if (_canProbeQuality) {
      unawaited(_probeQuality());
    } else {
      quality.value = NetworkQuality.good;
    }
  }

  Future<void> _probeQuality() async {
    if (!_canProbeQuality || _probing) return;
    if (!isOnline.value) {
      quality.value = NetworkQuality.offline;
      return;
    }

    _probing = true;
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
