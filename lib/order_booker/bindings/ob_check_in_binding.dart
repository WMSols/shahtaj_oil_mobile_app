import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_check_in_controller.dart';

class ObCheckInBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObCheckInController.new);
}
