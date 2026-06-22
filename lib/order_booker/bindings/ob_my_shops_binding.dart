import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_my_shops_controller.dart';

class ObMyShopsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObMyShopsController.new);
}
