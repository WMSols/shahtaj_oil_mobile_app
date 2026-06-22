import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dm_order_detail_controller.dart';

class DmOrderDetailBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(DmOrderDetailController.new);
}
