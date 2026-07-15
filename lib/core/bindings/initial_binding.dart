import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/services/profile_service.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/presence_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core services are normally registered in AppInitializer.setup().
    // Keep guarded fallbacks for test / atypical entry points.
    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService(), permanent: true);
    }
    if (!Get.isRegistered<OfflineCacheService>()) {
      Get.put(OfflineCacheService(Get.find<StorageService>()), permanent: true);
    }
    if (!Get.isRegistered<SessionService>()) {
      Get.put(SessionService(Get.find<StorageService>()), permanent: true);
    }
    if (!Get.isRegistered<ConnectivityService>()) {
      final connectivity = ConnectivityService();
      Get.put<ConnectivityService>(connectivity, permanent: true);
      connectivity.init();
    }
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(
        ApiClient(Get.find<StorageService>(), Get.find<SessionService>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<PresenceService>()) {
      final presence = PresenceService(
        Get.find<ApiClient>(),
        Get.find<SessionService>(),
        Get.find<StorageService>(),
      );
      Get.put<PresenceService>(presence, permanent: true);
      presence.init();
    }
    if (!Get.isRegistered<ProfileService>()) {
      Get.put<ProfileService>(
        ProfileService(Get.find<ApiClient>(), Get.find<SessionService>()),
        permanent: true,
      );
    }
  }
}
