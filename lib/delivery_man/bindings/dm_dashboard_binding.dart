import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dm_dashboard_controller.dart';

class DmDashboardBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(DmDashboardController.new);
}
