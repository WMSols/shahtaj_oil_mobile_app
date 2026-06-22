import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_order_create_controller.dart';

class ObOrderCreateBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObOrderCreateController.new);
}
