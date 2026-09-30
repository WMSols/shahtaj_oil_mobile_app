import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/walk_in_deliver/dm_walk_in_deliver_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/walk_in_deliver/dm_walk_in_deliver_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmWalkInDeliverBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    Get.lazyPut(
      () => DmWalkInDeliverController(
        Get.find<DmWalkInDeliverService>(),
        Get.find<DmVanService>(),
      ),
      fenix: true,
    );
  }
}
