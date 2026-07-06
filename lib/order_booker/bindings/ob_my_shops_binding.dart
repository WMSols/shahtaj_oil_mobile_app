import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_my_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_shop_service.dart';

class ObMyShopsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ObShopService>()) {
      Get.lazyPut<ObShopService>(() => ObShopService(Get.find<ApiClient>()));
    }
    Get.lazyPut<ObMyShopsController>(
      () => ObMyShopsController(Get.find<ObShopService>()),
    );
  }
}
