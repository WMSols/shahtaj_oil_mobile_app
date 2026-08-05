import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_shell_controller.dart';

class RecoveryManShellBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(RecoveryManShellController.new);
}
