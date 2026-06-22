import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/auth_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/services/auth_service.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AuthService(
        Get.find<ApiClient>(),
        Get.find<StorageService>(),
        Get.find<SessionService>(),
      ),
    );
    Get.lazyPut(AuthController.new);
  }
}
