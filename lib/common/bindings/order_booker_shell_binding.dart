import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/order_booker_shell_controller.dart';

class OrderBookerShellBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(OrderBookerShellController.new);
}
