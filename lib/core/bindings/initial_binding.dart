import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService(), permanent: true);
    }
    if (!Get.isRegistered<LocaleService>()) {
      Get.putAsync<LocaleService>(() async {
        final service = LocaleService(Get.find<StorageService>());
        return service.init();
      }, permanent: true);
    }
    if (!Get.isRegistered<SessionService>()) {
      Get.putAsync<SessionService>(() async {
        final service = SessionService(Get.find<StorageService>());
        return service.init();
      }, permanent: true);
    }
    if (!Get.isRegistered<ConnectivityService>()) {
      Get.putAsync<ConnectivityService>(() async {
        final service = ConnectivityService();
        return service.init();
      }, permanent: true);
    }
    if (!Get.isRegistered<ApiClient>()) {
      Get.putAsync<ApiClient>(() async {
        final client = ApiClient(
          Get.find<StorageService>(),
          Get.find<SessionService>(),
        );
        return client.init();
      }, permanent: true);
    }
  }
}
