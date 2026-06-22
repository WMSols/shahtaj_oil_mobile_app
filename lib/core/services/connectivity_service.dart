import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final RxBool isOnline = true.obs;
  final Connectivity _connectivity = Connectivity();

  Future<ConnectivityService> init() async {
    final result = await _connectivity.checkConnectivity();
    isOnline.value = _hasConnection(result);
    _connectivity.onConnectivityChanged.listen((result) {
      isOnline.value = _hasConnection(result);
    });
    return this;
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }
}
