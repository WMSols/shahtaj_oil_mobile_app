import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_visit_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_visit_service.dart';

class ObVisitDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ObVisitService>()) {
      Get.lazyPut<ObVisitService>(() => ObVisitService(Get.find<ApiClient>()));
    }
    Get.lazyPut<ObVisitDetailController>(
      () => ObVisitDetailController(Get.find<ObVisitService>()),
    );
  }
}
