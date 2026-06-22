import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/services/auth_service.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';

class AccountController extends GetxController {
  final SessionService _session = Get.find<SessionService>();
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoggingOut = false.obs;

  String get userName => _session.user.value?.name ?? AppTexts.defaultUserName;
  String get userEmail => _session.user.value?.email ?? '';

  Future<void> logout() async {
    isLoggingOut.value = true;
    try {
      await _authService.logout();
      Get.offAllNamed(AppRoutes.selectRole);
    } finally {
      isLoggingOut.value = false;
    }
  }
}
