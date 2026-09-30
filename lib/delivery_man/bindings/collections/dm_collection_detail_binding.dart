import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_collection_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmCollectionDetailBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    Get.lazyPut<DmCollectionDetailController>(
      () => DmCollectionDetailController(Get.find<DmRecoveryService>()),
    );
  }
}
