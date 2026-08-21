import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmTodayShopsBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    Get.lazyPut<DmTodayShopsController>(
      () => DmTodayShopsController(Get.find<DmCollectionStore>()),
      fenix: true,
    );
  }
}
