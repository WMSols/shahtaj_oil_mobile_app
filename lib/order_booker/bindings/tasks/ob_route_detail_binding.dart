import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/shell/ob_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/tasks/ob_route_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/history/ob_visit_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_task_service.dart';

class ObRouteDetailBinding extends Bindings {
  @override
  void dependencies() {
    OrderBookerServicesBinding.ensureRegistered();
    if (!Get.isRegistered<ObVisitService>()) {
      Get.lazyPut<ObVisitService>(
        () => ObVisitService(Get.find<ApiClient>()),
        fenix: true,
      );
    }
    Get.lazyPut<ObRouteDetailController>(
      () => ObRouteDetailController(
        Get.find<ObTaskService>(),
        visitService: Get.find<ObVisitService>(),
      ),
      fenix: true,
    );
  }
}
