import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/dashboard/rm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/dashboard/rm_dashboard_service.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

class RmDashboardBinding extends Bindings {
  @override
  void dependencies() {
    RecoveryManServicesBinding.ensureRegistered();
    Get.lazyPut<RmDashboardService>(
      () => RmDashboardService(Get.find<RmCollectionStore>()),
    );
    Get.lazyPut<RmDashboardController>(
      () => RmDashboardController(
        Get.find<RmDashboardService>(),
        Get.find<SessionService>(),
      ),
    );
  }
}
