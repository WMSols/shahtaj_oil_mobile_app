import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dm_deliver_controller.dart';

class DmDeliverBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(DmDeliverController.new);
}
