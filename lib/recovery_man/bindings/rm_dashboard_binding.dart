import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/rm_dashboard_controller.dart';

class RmDashboardBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(RmDashboardController.new);
}
