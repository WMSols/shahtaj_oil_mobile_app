import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/services/auth_service.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/role_route_resolver.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final UserRole role;

  @override
  void onInit() {
    super.onInit();
    role = Get.arguments as UserRole? ?? UserRole.orderBooker;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  Future<void> login() async {
    final login = emailController.text.trim();
    final password = passwordController.text;
    if (login.isEmpty || password.isEmpty) {
      AppToast.showError('Please enter login and password.');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.login(email: login, password: password, role: role);
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
