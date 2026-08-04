import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';

class DmDashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DmPickupService>()) {
      Get.put(DmPickupService(), permanent: true);
    }
    if (!Get.isRegistered<DmDeliveryService>()) {
      Get.put(DmDeliveryService(), permanent: true);
    }
    Get.lazyPut(
      () => DmDashboardController(
        Get.find<DmPickupService>(),
        Get.find<DmDeliveryService>(),
      ),
    );
  }
}
