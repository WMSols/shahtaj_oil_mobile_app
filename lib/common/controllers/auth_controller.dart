import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/services/auth_service.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/role_route_resolver.dart';

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
    isLoading.value = true;
    try {
      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
        role: role,
      );
      RoleRouteResolver.goToRoleHome(role);
    } finally {
      isLoading.value = false;
    }
  }
}
