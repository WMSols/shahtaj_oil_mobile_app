import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dm_pickup_controller.dart';

class DmPickupBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(DmPickupController.new);
}
