import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/reports/report_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/services/reports/reports_service.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';

class ReportDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ReportsService>()) {
      Get.put(ReportsService(Get.find<ApiClient>()), permanent: true);
    }
    Get.lazyPut(() => ReportDetailController(Get.find<ReportsService>()));
  }
}
