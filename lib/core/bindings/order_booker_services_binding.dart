import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_visit_cart_service.dart';

/// Keeps visit/task state alive across pushed routes (check-in, order create).
class OrderBookerServicesBinding {
  OrderBookerServicesBinding._();

  static void ensureRegistered() {
    if (!Get.isRegistered<ObTaskService>()) {
      Get.put<ObTaskService>(
        ObTaskService(Get.find<ApiClient>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<ObVisitCartService>()) {
      Get.put<ObVisitCartService>(
        ObVisitCartService(Get.find<ApiClient>()),
        permanent: true,
      );
    }
  }
}
