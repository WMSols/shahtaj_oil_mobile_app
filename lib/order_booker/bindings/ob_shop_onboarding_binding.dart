import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shop_onboarding_controller.dart';

class ObShopOnboardingBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObShopOnboardingController.new);
}
