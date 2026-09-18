import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/van_stock/dm_van_stock_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmVanStockBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    if (!Get.isRegistered<DmVanService>()) {
      Get.put(DmVanService(Get.find<ApiClient>()), permanent: true);
    }
    Get.lazyPut(() => DmVanStockController(Get.find<DmVanService>()));
  }
}
