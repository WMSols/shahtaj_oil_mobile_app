import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/services/auth_service.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
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

  Future<void> login() async {
    isLoading.value = true;
    try {
      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
        role: role,
      );
      _navigateToRoleHome(role);
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateToRoleHome(UserRole role) {
    switch (role) {
      case UserRole.orderBooker:
        Get.offAllNamed(AppRoutes.orderBooker);
      case UserRole.deliveryMan:
        Get.offAllNamed(AppRoutes.deliveryMan);
      case UserRole.recoveryMan:
        Get.offAllNamed(AppRoutes.recoveryMan);
    }
  }
}
