import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_order_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_order_detail_service.dart';

class ObOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ObOrderDetailService>()) {
      Get.lazyPut<ObOrderDetailService>(
        () => ObOrderDetailService(Get.find<ApiClient>()),
      );
    }
    Get.lazyPut<ObOrderDetailController>(
      () => ObOrderDetailController(Get.find<ObOrderDetailService>()),
    );
  }
}
