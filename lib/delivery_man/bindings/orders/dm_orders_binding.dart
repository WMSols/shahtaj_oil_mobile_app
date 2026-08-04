import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_orders_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';

class DmOrdersBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DmDeliveryService>()) {
      Get.put(DmDeliveryService(), permanent: true);
    }
    Get.lazyPut(() => DmOrdersController(Get.find<DmDeliveryService>()));
  }
}
