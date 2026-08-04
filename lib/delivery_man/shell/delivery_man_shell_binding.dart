import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/shell/delivery_man_shell_controller.dart';

class DeliveryManShellBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(DeliveryManShellController.new);
}
