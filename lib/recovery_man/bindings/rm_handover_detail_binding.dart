import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/rm_handover_detail_controller.dart';

class RmHandoverDetailBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(RmHandoverDetailController.new);
}
