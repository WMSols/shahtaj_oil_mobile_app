import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_visit_detail_controller.dart';

class ObVisitDetailBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObVisitDetailController.new);
}
