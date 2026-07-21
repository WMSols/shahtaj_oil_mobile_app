import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/services/auth_service.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/role_route_resolver.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storage = Get.find<StorageService>();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool rememberMe = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final UserRole role;

  @override
  void onInit() {
    super.onInit();
    role = Get.arguments as UserRole? ?? UserRole.orderBooker;
    _restoreRememberedCredentials();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  void setRememberMe(bool value) => rememberMe.value = value;

  Future<void> _restoreRememberedCredentials() async {
    final enabled = await _storage.isRememberMeEnabled(role);
    rememberMe.value = enabled;
    if (!enabled) return;

    final login = await _storage.getRememberedLogin(role);
    final password = await _storage.getRememberedPassword(role);
    if (login != null && login.isNotEmpty) {
      emailController.text = login;
    }
    if (password != null && password.isNotEmpty) {
      passwordController.text = password;
    }
  }

  Future<void> _persistRememberMe({
    required String login,
    required String password,
  }) async {
    if (rememberMe.value) {
      await _storage.saveRememberedCredentials(
        role: role,
        login: login,
        password: password,
      );
    } else {
      await _storage.clearRememberedCredentials(role);
    }
  }

  Future<void> login() async {
    final login = emailController.text.trim();
    final password = passwordController.text;

    // Order Booker uses live API — credentials required.
    // DM/RM are UI-only for now: allow empty fields and local mock session.
    if (role == UserRole.orderBooker && (login.isEmpty || password.isEmpty)) {
      AppToast.showError('Please enter login and password.');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.login(email: login, password: password, role: role);
      await _persistRememberMe(login: login, password: password);
      RoleRouteResolver.goToRoleHome(role);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError('Login failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
