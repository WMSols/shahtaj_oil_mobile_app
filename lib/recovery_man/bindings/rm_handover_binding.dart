import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/rm_handover_controller.dart';

class RmHandoverBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(RmHandoverController.new);
}
