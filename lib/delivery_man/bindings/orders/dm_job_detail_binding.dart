import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_job_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmJobDetailBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    Get.lazyPut(() => DmJobDetailController(Get.find<DmPlanService>()));
  }
}
