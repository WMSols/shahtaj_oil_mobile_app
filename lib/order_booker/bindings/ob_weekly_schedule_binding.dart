import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_weekly_schedule_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_dashboard_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_weekly_schedule_service.dart';

class ObWeeklyScheduleBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ObWeeklyScheduleService>()) {
      Get.lazyPut<ObWeeklyScheduleService>(
        () => ObWeeklyScheduleService(Get.find<ApiClient>()),
      );
    }
    if (!Get.isRegistered<ObDashboardService>()) {
      Get.lazyPut<ObDashboardService>(
        () => ObDashboardService(Get.find<ApiClient>()),
      );
    }
    Get.lazyPut<ObWeeklyScheduleController>(
      () => ObWeeklyScheduleController(
        Get.find<ObWeeklyScheduleService>(),
        Get.find<ObDashboardService>(),
      ),
    );
  }
}
