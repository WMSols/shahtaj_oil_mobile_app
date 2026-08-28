import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/van_stock/dm_van_stock_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van_stock/dm_van_stock_service.dart';

class DmVanStockBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DmPickupService>()) {
      Get.put(DmPickupService(), permanent: true);
    }
    if (!Get.isRegistered<DmDeliveryService>()) {
      Get.put(DmDeliveryService(), permanent: true);
    }
    if (!Get.isRegistered<DmVanStockService>()) {
      Get.put(
        DmVanStockService(
          pickup: Get.find<DmPickupService>(),
          delivery: Get.find<DmDeliveryService>(),
        ),
        permanent: true,
      );
    }
    Get.lazyPut(() => DmVanStockController(Get.find<DmVanStockService>()));
  }
}
