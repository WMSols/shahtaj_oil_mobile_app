import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/shell/ob_shell_controller.dart';

class OrderBookerShellBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(OrderBookerShellController.new);
}
