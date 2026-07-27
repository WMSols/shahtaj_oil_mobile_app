import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

/// Monitors device location services (GPS) for a sticky in-app banner,
/// similar to [ConnectivityService] for internet.
class LocationService extends GetxService {
  final RxBool isLocationEnabled = true.obs;
  StreamSubscription<ServiceStatus>? _subscription;
  bool _listening = false;
  bool _wasOff = false;

  Future<LocationService> init() async {
    if (_listening) return this;
    _listening = true;

    try {
      isLocationEnabled.value = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled.value) _wasOff = true;
    } catch (_) {
      // Keep default; stream will correct state when available.
    }

    _subscription = Geolocator.getServiceStatusStream().listen(_onStatus);
    return this;
  }

  void _onStatus(ServiceStatus status) {
    final enabled = status == ServiceStatus.enabled;
    final wasEnabled = isLocationEnabled.value;
    isLocationEnabled.value = enabled;

    if (!enabled) {
      _wasOff = true;
      return;
    }

    if (_wasOff || !wasEnabled) {
      _wasOff = false;
      AppToast.showSuccess(AppTexts.locationServicesOn);
    }
  }

  Future<bool> refresh() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) _wasOff = true;
      isLocationEnabled.value = enabled;
      return enabled;
    } catch (_) {
      return isLocationEnabled.value;
    }
  }

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  void onClose() {
    _subscription?.cancel();
    _subscription = null;
    _listening = false;
    super.onClose();
  }
}
