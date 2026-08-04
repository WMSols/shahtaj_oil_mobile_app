import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/pickup/dm_pickup_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';

class DmPickupBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DmPickupService>()) {
      Get.put(DmPickupService(), permanent: true);
    }
    Get.lazyPut(() => DmPickupController(Get.find<DmPickupService>()));
  }
}
