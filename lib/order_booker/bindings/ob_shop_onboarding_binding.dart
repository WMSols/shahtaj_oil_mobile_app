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

    // Recreate so register vs edit (`:id`) always start from route params.
    if (Get.isRegistered<ObShopOnboardingController>()) {
      Get.delete<ObShopOnboardingController>(force: true);
    }
    Get.put<ObShopOnboardingController>(
      ObShopOnboardingController(Get.find<ObShopService>()),
    );
  }
}
