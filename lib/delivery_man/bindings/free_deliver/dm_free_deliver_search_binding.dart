import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/free_deliver/dm_free_deliver_search_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/free_deliver/dm_free_deliver_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmFreeDeliverSearchBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    Get.lazyPut(
      () => DmFreeDeliverSearchController(Get.find<DmFreeDeliverService>()),
    );
  }
}
