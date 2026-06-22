import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shop_detail_controller.dart';

class ObShopDetailBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObShopDetailController.new);
}
