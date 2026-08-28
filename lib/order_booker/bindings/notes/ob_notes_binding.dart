import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/shell/ob_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/notes/ob_notes_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_task_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_cart_service.dart';

class ObNotesBinding extends Bindings {
  @override
  void dependencies() {
    OrderBookerServicesBinding.ensureRegistered();
    Get.lazyPut<ObNotesController>(
      () => ObNotesController(
        Get.find<ObTaskService>(),
        Get.find<ObVisitCartService>(),
      ),
    );
  }
}
