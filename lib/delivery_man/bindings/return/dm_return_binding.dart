import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/return/dm_return_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/return/dm_return_service.dart';

class DmReturnBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DmDeliveryService>()) {
      Get.put(DmDeliveryService(), permanent: true);
    }
    if (!Get.isRegistered<DmReturnService>()) {
      Get.put(DmReturnService(), permanent: true);
    }
    Get.lazyPut(() => DmReturnController(Get.find<DmReturnService>()));
  }
}
