import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/pickup/dm_pickup_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/load/dm_load_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmPickupBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    if (!Get.isRegistered<DmLoadService>()) {
      Get.put(DmLoadService(Get.find<ApiClient>()), permanent: true);
    }
    Get.lazyPut(() => DmPickupController(Get.find<DmLoadService>()));
  }
}
