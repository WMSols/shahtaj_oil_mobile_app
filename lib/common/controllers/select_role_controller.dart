import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class SelectRoleController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final Rxn<UserRole> selectedRole = Rxn<UserRole>();

  @override
  void onInit() {
    super.onInit();
    _restoreSavedRole();
  }

  Future<void> _restoreSavedRole() async {
    final roleStr = await _storage.getRole();
    if (roleStr == null) return;
    selectedRole.value = UserRole.values.firstWhere(
      (role) => role.name == roleStr,
      orElse: () => UserRole.orderBooker,
    );
  }

  void selectRole(UserRole role) => selectedRole.value = role;

  Future<void> continueToLogin() async {
    final role = selectedRole.value;
    if (role == null) return;
    await _storage.saveRole(role.name);
    Get.offAllNamed(AppRoutes.login, arguments: role);
  }
}
