import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/bindings/order_booker_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_route_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';

class ObRouteDetailBinding extends Bindings {
  @override
  void dependencies() {
    OrderBookerServicesBinding.ensureRegistered();
    Get.lazyPut<ObRouteDetailController>(
      () => ObRouteDetailController(Get.find<ObTaskService>()),
    );
  }
}
