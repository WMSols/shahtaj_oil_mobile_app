import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_dashboard_controller.dart';

class ObDashboardBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObDashboardController.new);
}
