import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_shop_closed_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmShopClosedBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    Get.lazyPut(() => DmShopClosedController(Get.find<DmPlanService>()));
  }
}
