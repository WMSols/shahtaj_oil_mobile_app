import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shop_edit_controller.dart';

class ObShopEditBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObShopEditController.new);
}
