import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/wallet/dm_wallet_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmWalletBinding extends Bindings {
  @override
  void dependencies() {
    DmServicesBinding.ensureRegistered();
    Get.lazyPut(() => DmWalletController(Get.find<DmRecoveryService>()));
  }
}
