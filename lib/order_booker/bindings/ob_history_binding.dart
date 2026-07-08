import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_visit_service.dart';

class ObHistoryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ObVisitService>()) {
      Get.lazyPut<ObVisitService>(() => ObVisitService(Get.find<ApiClient>()));
    }
    Get.lazyPut<ObHistoryController>(
      () => ObHistoryController(Get.find<ObVisitService>()),
    );
  }
}
