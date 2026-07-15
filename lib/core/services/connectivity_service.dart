import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

class ConnectivityService extends GetxService {
  final RxBool isOnline = true.obs;
  final Connectivity _connectivity = Connectivity();
  bool _wasOffline = false;
  bool _listening = false;

  Future<ConnectivityService> init() async {
    if (_listening) return this;
    _listening = true;

    try {
      final result = await _connectivity.checkConnectivity();
      isOnline.value = _hasConnection(result);
      if (!isOnline.value) _wasOffline = true;
    } catch (_) {
      // Keep default; listener will correct state.
    }

    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    return this;
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) {
    final online = _hasConnection(result);
    final wasOnline = isOnline.value;
    isOnline.value = online;

    if (!online) {
      _wasOffline = true;
      // Sticky error snackbars sit in the overlay above the app builder;
      // dismiss them so the persistent offline banner stays visible.
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      return;
    }

    if (_wasOffline || !wasOnline) {
      _wasOffline = false;
      AppToast.showSuccess(AppTexts.backOnline);
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
}
