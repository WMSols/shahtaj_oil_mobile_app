import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/account_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/services/auth_service.dart';
import 'package:shahtaj_oil_mobile_app/common/services/profile_service.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AuthService(
        Get.find<ApiClient>(),
        Get.find<StorageService>(),
        Get.find<SessionService>(),
      ),
    );
    if (!Get.isRegistered<ProfileService>()) {
      Get.put(
        ProfileService(Get.find<ApiClient>(), Get.find<SessionService>()),
        permanent: true,
      );
    }
    Get.lazyPut(
      () => AccountController(
        Get.find<SessionService>(),
        Get.find<ProfileService>(),
        Get.find<AuthService>(),
      ),
    );
  }
}
