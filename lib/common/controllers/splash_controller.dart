import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class SplashController extends GetxController {
  final SessionService _session = Get.find<SessionService>();
  final StorageService _storage = Get.find<StorageService>();

  @override
  void onReady() {
    super.onReady();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final token = await _storage.getToken();
      if (token != null &&
          token.isNotEmpty &&
          _session.role.value != null) {
        _navigateToRoleHome(_session.role.value!);
        return;
      }

      final onboardingCompleted = await _storage.isOnboardingCompleted();
      if (!onboardingCompleted) {
        Get.offAllNamed(AppRoutes.onboarding);
        return;
      }

      final savedRole = await _resolveSavedRole();
      Get.offAllNamed(AppRoutes.login, arguments: savedRole);
    } catch (error, stackTrace) {
      debugPrint('Splash bootstrap failed: $error\n$stackTrace');
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  Future<UserRole> _resolveSavedRole() async {
    final roleStr = await _storage.getRole();
    if (roleStr == null) return UserRole.orderBooker;
    return UserRole.values.firstWhere(
      (role) => role.name == roleStr,
      orElse: () => UserRole.orderBooker,
    );
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
