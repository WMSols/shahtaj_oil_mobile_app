import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/deliver/dm_deliver_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';

class DmDeliverBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DmDeliveryService>()) {
      Get.put(DmDeliveryService(), permanent: true);
    }
    Get.lazyPut(() => DmDeliverController(Get.find<DmDeliveryService>()));
  }
}
