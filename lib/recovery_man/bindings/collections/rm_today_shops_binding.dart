import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

class RmTodayShopsBinding extends Bindings {
  @override
  void dependencies() {
    RecoveryManServicesBinding.ensureRegistered();
    Get.lazyPut<RmTodayShopsController>(
      () => RmTodayShopsController(Get.find<RmCollectionStore>()),
      fenix: true,
    );
  }
}
