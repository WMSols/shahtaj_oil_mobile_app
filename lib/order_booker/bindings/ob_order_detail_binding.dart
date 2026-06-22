import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_order_detail_controller.dart';

class ObOrderDetailBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObOrderDetailController.new);
}
