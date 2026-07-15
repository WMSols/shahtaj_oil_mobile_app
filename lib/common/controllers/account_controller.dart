import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/user_model.dart';
import 'package:shahtaj_oil_mobile_app/common/services/auth_service.dart';
import 'package:shahtaj_oil_mobile_app/common/services/profile_service.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';

class AccountController extends GetxController {
  AccountController(this._session, this._profileService, this._authService);

  final SessionService _session;
  final ProfileService _profileService;
  final AuthService _authService;

  final RxBool isLoading = false.obs;
  final RxBool isLoggingOut = false.obs;
  final RxnString loadError = RxnString();

  UserModel? get user => _session.user.value;
  UserRole? get role => _session.role.value ?? user?.role;

  bool get hasProfile => user != null && role != null;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile({bool force = false}) async {
    if (_session.role.value == null) {
      loadError.value = AppTexts.error;
      return;
    }

    if (!force && hasProfile) {
      isLoading.value = false;
      return;
    }

    if (!hasProfile) {
      isLoading.value = true;
    }
    try {
      await _profileService.fetchCurrentUser();
      loadError.value = null;
    } catch (_) {
      if (!hasProfile) {
        loadError.value = AppTexts.error;
      }
    } finally {
      isLoading.value = false;
    }
  }

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
