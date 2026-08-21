import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_collection_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmCollectionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    Get.lazyPut<DmCollectionHistoryController>(
      () => DmCollectionHistoryController(Get.find<DmCollectionStore>()),
    );
  }
}
