import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/reports/reports_list_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/services/reports/reports_service.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';

class ReportsListBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ReportsService>()) {
      Get.put(ReportsService(Get.find<ApiClient>()), permanent: true);
    }
    Get.lazyPut(() => ReportsListController(Get.find<ReportsService>()));
  }
}
