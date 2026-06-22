import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/recovery_man_shell_controller.dart';

class RecoveryManShellBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(RecoveryManShellController.new);
}
