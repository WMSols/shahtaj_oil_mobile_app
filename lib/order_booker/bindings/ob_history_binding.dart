import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_history_controller.dart';

class ObHistoryBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObHistoryController.new);
}
