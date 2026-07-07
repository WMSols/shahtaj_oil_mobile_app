import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_order_create_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_visit_cart_service.dart';

class ObOrderCreateBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ObTaskService>()) {
      Get.lazyPut<ObTaskService>(() => ObTaskService(Get.find<ApiClient>()));
    }
    if (!Get.isRegistered<ObVisitCartService>()) {
      Get.lazyPut<ObVisitCartService>(
        () => ObVisitCartService(Get.find<ApiClient>()),
      );
    }
    Get.lazyPut<ObOrderCreateController>(
      () => ObOrderCreateController(
        Get.find<ObTaskService>(),
        Get.find<ObVisitCartService>(),
      ),
    );
  }
}
