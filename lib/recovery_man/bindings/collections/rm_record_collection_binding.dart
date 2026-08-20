import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_record_collection_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

class RmRecordCollectionBinding extends Bindings {
  @override
  void dependencies() {
    RecoveryManServicesBinding.ensureRegistered();
    Get.lazyPut<RmRecordCollectionController>(
      () => RmRecordCollectionController(Get.find<RmCollectionStore>()),
    );
  }
}
