import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shops_controller.dart';

class ObShopsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObShopsController.new);
}
