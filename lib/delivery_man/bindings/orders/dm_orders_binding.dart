import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_orders_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/session/dm_session_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmOrdersBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    if (!Get.isRegistered<DmPlanService>()) {
      Get.put(DmPlanService(Get.find<ApiClient>()), permanent: true);
    }
    Get.lazyPut(
      () => DmOrdersController(
        Get.find<DmPlanService>(),
        Get.find<DmSessionService>(),
      ),
    );
  }
}
