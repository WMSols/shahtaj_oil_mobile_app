import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
