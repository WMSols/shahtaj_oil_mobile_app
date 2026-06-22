import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dm_delivery_detail_controller.dart';

class DmDeliveryDetailBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(DmDeliveryDetailController.new);
}
