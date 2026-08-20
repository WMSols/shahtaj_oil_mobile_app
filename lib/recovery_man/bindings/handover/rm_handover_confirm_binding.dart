import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/handover/rm_handover_confirm_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

class RmHandoverConfirmBinding extends Bindings {
  @override
  void dependencies() {
    RecoveryManServicesBinding.ensureRegistered();
    Get.lazyPut<RmHandoverConfirmController>(
      () => RmHandoverConfirmController(Get.find<RmCollectionStore>()),
    );
  }
}
