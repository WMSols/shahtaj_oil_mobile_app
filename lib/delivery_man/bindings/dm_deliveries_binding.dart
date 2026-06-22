import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dm_deliveries_controller.dart';

class DmDeliveriesBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(DmDeliveriesController.new);
}
