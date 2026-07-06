import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shop_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_shop_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';

class ObShopDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ObShopService>()) {
      Get.lazyPut<ObShopService>(() => ObShopService(Get.find<ApiClient>()));
    }
    if (!Get.isRegistered<ObTaskService>()) {
      Get.lazyPut<ObTaskService>(() => ObTaskService(Get.find<ApiClient>()));
    }
    Get.lazyPut<ObShopDetailController>(
      () => ObShopDetailController(
        Get.find<ObShopService>(),
        Get.find<ObTaskService>(),
      ),
    );
  }
}
