import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

class ConnectivityService extends GetxService {
  final RxBool isOnline = true.obs;
  final Connectivity _connectivity = Connectivity();
  bool _wasOffline = false;

  Future<ConnectivityService> init() async {
    final result = await _connectivity.checkConnectivity();
    isOnline.value = _hasConnection(result);
    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    return this;
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) {
    final online = _hasConnection(result);
    isOnline.value = online;

    if (!online) {
      _wasOffline = true;
      return;
    }

    if (_wasOffline) {
      _wasOffline = false;
      AppToast.showInformation(AppTexts.backOnline);
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
