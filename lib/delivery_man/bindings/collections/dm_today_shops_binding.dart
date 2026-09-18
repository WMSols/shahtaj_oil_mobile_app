import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/free_deliver/dm_free_deliver_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmTodayShopsBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    Get.lazyPut(
      () => DmTodayShopsController(
        Get.find<DmPlanService>(),
        Get.find<DmFreeDeliverService>(),
      ),
      fenix: true,
    );
  }
}
