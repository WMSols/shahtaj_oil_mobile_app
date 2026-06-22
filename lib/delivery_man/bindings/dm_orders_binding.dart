import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dm_orders_controller.dart';

class DmOrdersBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(DmOrdersController.new);
}
