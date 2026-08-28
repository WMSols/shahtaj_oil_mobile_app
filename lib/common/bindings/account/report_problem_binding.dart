import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/account/report_problem_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/services/account/report_problem_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';

class ReportProblemBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ReportProblemService>()) {
      Get.put(ReportProblemService(), permanent: true);
    }
    Get.lazyPut(
      () => ReportProblemController(
        Get.find<ReportProblemService>(),
        Get.find<SessionService>(),
      ),
    );
  }
}
