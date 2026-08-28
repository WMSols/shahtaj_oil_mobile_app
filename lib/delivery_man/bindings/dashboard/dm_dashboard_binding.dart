import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/dashboard/dm_collection_dashboard_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van_stock/dm_van_stock_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmDashboardBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();

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
    if (!Get.isRegistered<DmCollectionDashboardService>()) {
      Get.put(
        DmCollectionDashboardService(Get.find<DmCollectionStore>()),
        permanent: true,
      );
    }

    Get.lazyPut(
      () => DmDashboardController(
        Get.find<DmPickupService>(),
        Get.find<DmDeliveryService>(),
        Get.find<DmCollectionDashboardService>(),
        Get.find<DmVanStockService>(),
      ),
    );
  }
}
