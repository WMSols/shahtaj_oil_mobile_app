import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

/// Keeps server-side last-seen fresh while the app is foregrounded.
///
/// The heartbeat API currently returns `online_status: "away"` even while the
/// user is actively using the app, so local presence is derived from lifecycle /
/// connectivity after a successful ping (online in foreground, away when
/// backgrounded, offline when disconnected).
class PresenceService extends GetxService with WidgetsBindingObserver {
  PresenceService(this._api, this._session, this._storage);

  static const _interval = Duration(seconds: 100);

  final ApiClient _api;
  final SessionService _session;
  final StorageService _storage;

  Timer? _timer;
  bool _sending = false;
  bool _foreground = true;
  Worker? _sessionWorker;
  Worker? _connectivityWorker;

  Future<PresenceService> init() async {
    WidgetsBinding.instance.addObserver(this);
    _sessionWorker = ever(_session.user, (_) => _syncHeartbeat());
    if (Get.isRegistered<ConnectivityService>()) {
      _connectivityWorker = ever(
        Get.find<ConnectivityService>().isOnline,
        (_) => _syncHeartbeat(),
      );
    }
    _syncHeartbeat();
    return this;
  }

  @override
  void onClose() {
    _sessionWorker?.dispose();
    _connectivityWorker?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _stop();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (!_foreground) {
      _stop();
      unawaited(_setLocalPresence(PresenceStatus.away));
      return;
    }
    _syncHeartbeat();
  }

  /// Sets local presence to online and pings the server immediately.
  /// Call after login so the UI does not wait for the periodic timer.
  Future<void> markOnlineNow() async {
    if (!_hasSession) return;
    await _setLocalPresence(PresenceStatus.online);
    _foreground = true;
    _stop();
    _start();
  }

  void _syncHeartbeat() {
    if (!_hasSession) {
      _stop();
      return;
    }

    if (!_isNetworkOnline) {
      _stop();
      unawaited(_setLocalPresence(PresenceStatus.offline));
      return;
    }

    if (!_foreground) {
      _stop();
      unawaited(_setLocalPresence(PresenceStatus.away));
      return;
    }

    _start();
  }

  bool get _hasSession => _session.user.value != null;

  bool get _isNetworkOnline {
    if (!Get.isRegistered<ConnectivityService>()) return true;
    return Get.find<ConnectivityService>().isOnline.value;
  }

  bool get _shouldRun => _hasSession && _isNetworkOnline && _foreground;

  void _start() {
    if (_timer != null) return;
    unawaited(_sendHeartbeat());
    _timer = Timer.periodic(_interval, (_) => unawaited(_sendHeartbeat()));
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _sendHeartbeat() async {
    if (_sending || !_shouldRun) return;
    _sending = true;
    try {
      final token = await _storage.getToken();
      if (token == null || token.isEmpty) return;

      await _api.postData(ApiEndpoints.obPresenceHeartbeat, data: const {});

      // Heartbeat succeeded while foregrounded → user is online for UI.
      // Backend may still echo "away"; ignore that while the app is in use.
      await _setLocalPresence(PresenceStatus.online);
    } catch (_) {
      // Presence is best-effort; don't interrupt the user.
    } finally {
      _sending = false;
    }
  }

  Future<void> _setLocalPresence(PresenceStatus status) async {
    final user = _session.user.value;
    if (user == null || user.presenceStatus == status) return;
    await _session.updateUser(user.copyWith(presenceStatus: status));
  }
}
