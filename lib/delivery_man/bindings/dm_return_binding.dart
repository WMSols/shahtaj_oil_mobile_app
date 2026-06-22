import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dm_return_controller.dart';

class DmReturnBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(DmReturnController.new);
}
