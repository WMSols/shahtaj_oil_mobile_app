import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_routes_controller.dart';

class ObRoutesBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObRoutesController.new);
}
