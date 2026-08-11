import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/dashboard/ob_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/dashboard/ob_dashboard_service.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_task_service.dart';

class ObDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ObDashboardService>(
      () => ObDashboardService(Get.find<ApiClient>()),
    );
    Get.lazyPut<ObDashboardController>(
      () => ObDashboardController(
        Get.find<ObDashboardService>(),
        Get.find<SessionService>(),
        Get.find<ObTaskService>(),
      ),
    );
  }
}
