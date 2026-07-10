import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_targets_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_targets_service.dart';

class ObTargetsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ObTargetsService>()) {
      Get.lazyPut<ObTargetsService>(
        () => ObTargetsService(Get.find<ApiClient>()),
      );
    }
    Get.lazyPut<ObTargetsController>(
      () => ObTargetsController(Get.find<ObTargetsService>()),
    );
  }
}
