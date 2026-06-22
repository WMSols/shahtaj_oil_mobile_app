import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_route_detail_controller.dart';

class ObRouteDetailBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ObRouteDetailController.new);
}
