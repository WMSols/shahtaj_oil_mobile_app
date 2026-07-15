import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shop_onboarding_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_shop_service.dart';

class ObShopOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ObShopService>()) {
      Get.lazyPut<ObShopService>(() => ObShopService(Get.find<ApiClient>()));
    }

    // Do not force-delete while the shell may still be showing/animating the
    // register form — that disposes TextEditingControllers mid-gesture.
    if (!Get.isRegistered<ObShopOnboardingController>()) {
      Get.put<ObShopOnboardingController>(
        ObShopOnboardingController(Get.find<ObShopService>()),
      );
    }
  }
}
