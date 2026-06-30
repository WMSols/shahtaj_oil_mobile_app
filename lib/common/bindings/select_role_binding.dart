import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/select_role_controller.dart';

class SelectRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SelectRoleController());
  }
}
