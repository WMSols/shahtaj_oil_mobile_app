import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/history/ob_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/history/ob_visit_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/shell/ob_services_binding.dart';

class ObHistoryBinding extends Bindings {
  @override
  void dependencies() {
    OrderBookerServicesBinding.ensureRegistered();
    Get.lazyPut<ObVisitService>(() => ObVisitService(Get.find<ApiClient>()));
    Get.lazyPut<ObHistoryController>(
      () => ObHistoryController(Get.find<ObVisitService>()),
    );
  }
}
