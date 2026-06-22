import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';

class SelectRoleController extends GetxController {
  final Rxn<UserRole> selectedRole = Rxn<UserRole>();

  void selectRole(UserRole role) => selectedRole.value = role;

  void continueToOnboarding() {
    if (selectedRole.value == null) return;
    Get.toNamed(AppRoutes.onboarding, arguments: selectedRole.value);
  }
}
