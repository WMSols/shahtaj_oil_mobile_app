import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_shop_invoices_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

class RmShopInvoicesBinding extends Bindings {
  @override
  void dependencies() {
    RecoveryManServicesBinding.ensureRegistered();
    Get.lazyPut<RmShopInvoicesController>(
      () => RmShopInvoicesController(Get.find<RmCollectionStore>()),
    );
  }
}
