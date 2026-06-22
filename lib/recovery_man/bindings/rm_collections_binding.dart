import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/rm_collections_controller.dart';

class RmCollectionsBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(RmCollectionsController.new);
}
