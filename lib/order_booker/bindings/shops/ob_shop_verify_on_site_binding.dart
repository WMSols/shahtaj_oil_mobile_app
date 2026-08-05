import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/shell/order_booker_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/shops/ob_shop_verify_on_site_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/shops/ob_shop_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_task_service.dart';

class ObShopVerifyOnSiteBinding extends Bindings {
  @override
  void dependencies() {
    OrderBookerServicesBinding.ensureRegistered();
    if (!Get.isRegistered<ObShopService>()) {
      Get.lazyPut<ObShopService>(() => ObShopService(Get.find<ApiClient>()));
    }
    Get.lazyPut<ObShopVerifyOnSiteController>(
      () => ObShopVerifyOnSiteController(
        Get.find<ObTaskService>(),
        Get.find<ObShopService>(),
      ),
    );
  }
}
