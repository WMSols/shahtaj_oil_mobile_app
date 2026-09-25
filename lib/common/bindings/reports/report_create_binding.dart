import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/reports/report_create_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/services/reports/reports_service.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';

class ReportCreateBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ReportsService>()) {
      Get.put(ReportsService(Get.find<ApiClient>()), permanent: true);
    }
    Get.lazyPut(() => ReportCreateController(Get.find<ReportsService>()));
  }
}
