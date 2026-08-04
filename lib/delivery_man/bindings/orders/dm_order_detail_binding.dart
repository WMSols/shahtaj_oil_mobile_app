import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_order_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';

class DmOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DmDeliveryService>()) {
      Get.put(DmDeliveryService(), permanent: true);
    }
    if (!Get.isRegistered<DmPickupService>()) {
      Get.put(DmPickupService(), permanent: true);
    }
    Get.lazyPut(
      () => DmOrderDetailController(
        Get.find<DmDeliveryService>(),
        Get.find<DmPickupService>(),
      ),
    );
  }
}
