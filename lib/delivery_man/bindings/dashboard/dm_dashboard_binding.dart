import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/load/dm_load_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/session/dm_session_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmDashboardBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    Get.lazyPut(
      () => DmDashboardController(
        Get.find<DmSessionService>(),
        Get.find<DmLoadService>(),
        Get.find<DmPlanService>(),
        Get.find<DmVanService>(),
        Get.find<DmRecoveryService>(),
      ),
    );
  }
}
