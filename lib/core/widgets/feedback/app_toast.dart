import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

enum AppToastStatus { success, information, warning, error }

/// Transient bottom feedback using a full-width grounded bar.
abstract class AppToast {
  AppToast._();

  static const Duration _duration = Duration(seconds: 2);

  static AppToastStyle _styleFor(AppToastStatus status) {
    return switch (status) {
      AppToastStatus.success => AppToastStyle.success,
      AppToastStatus.information => AppToastStyle.information,
      AppToastStatus.warning => AppToastStyle.warning,
      AppToastStatus.error => AppToastStyle.error,
    };
  }

  static void showSuccess(String message) {
    _show(status: AppToastStatus.success, message: message);
  }

  static void showInformation(String message) {
    _show(status: AppToastStatus.information, message: message);
  }

  static void showWarning(String message) {
    _show(status: AppToastStatus.warning, message: message);
  }

  static void showError(String message) {
    _show(status: AppToastStatus.error, message: message);
  }

  static void _show({required AppToastStatus status, required String message}) {
    final context = Get.context;
    if (context == null || message.trim().isEmpty) return;

    final style = _styleFor(status);

    Get.rawSnackbar(
      messageText: AppToastBar(message: message.trim(), style: style),
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: Colors.transparent,
      overlayBlur: 0,
      overlayColor: Colors.transparent,
      margin: EdgeInsets.zero,
      borderRadius: 0,
      padding: EdgeInsets.zero,
      duration: _duration,
    );
  }
}

/// Visual variants for toast and offline bottom bars.
enum AppToastStyle { neutral, success, information, warning, error }

/// Theme-aware background and foreground colors for [AppToastBar].
abstract class AppToastColors {
  AppToastColors._();

  static Color background(AppToastStyle style) {
    return switch (style) {
      AppToastStyle.neutral => AppColors.darkGrey,
      AppToastStyle.success => AppColors.success,
      AppToastStyle.information => AppColors.information,
      AppToastStyle.warning => AppColors.warning,
      AppToastStyle.error => AppColors.error,
    };
  }

  static Color foreground(AppToastStyle style) {
    return switch (style) {
      AppToastStyle.neutral => AppColors.white,
      AppToastStyle.success ||
      AppToastStyle.information ||
      AppToastStyle.warning ||
      AppToastStyle.error => AppColors.white,
    };
  }
}

/// Full-width bottom bar with a single centered message (offline banner, toasts).
class AppToastBar extends StatelessWidget {
  const AppToastBar({super.key, required this.message, required this.style});

  final String message;
  final AppToastStyle style;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppToastColors.background(style);
    final foregroundColor = AppToastColors.foreground(style);

    return Material(
      color: backgroundColor,
      child: SafeArea(
        top: false,
        child: Center(
          child: Padding(
            padding: AppSpacing.symmetric(context, v: 0.005, h: 0.04),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelText(context).copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
