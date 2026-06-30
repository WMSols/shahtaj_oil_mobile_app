import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  @override
  void dependencies() {
    Get.put(OnboardingController());
  }
}
