import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_icon_button.dart';

enum AppToastStatus { success, information, warning, error }

/// Bottom feedback bar hosted in the app [Stack] (see [AppToastHost]).
///
/// Not backed by GetX snackbars — those caused [LateInitializationError] when
/// closing sticky errors or navigating with [Get.back].
abstract class AppToast {
  AppToast._();

  static const Duration _autoDismiss = Duration(seconds: 2);

  static final Rxn<_AppToastPayload> _payload = Rxn<_AppToastPayload>();
  static Timer? _timer;

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

  static void close() {
    _timer?.cancel();
    _timer = null;
    _payload.value = null;
  }

  static void _show({required AppToastStatus status, required String message}) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    _timer?.cancel();
    _timer = null;

    final style = _styleFor(status);
    final isError = status == AppToastStatus.error;

    _payload.value = _AppToastPayload(
      message: trimmed,
      style: style,
      showClose: isError,
      // Bust identical consecutive messages so Obx/Dismissible remount.
      token: DateTime.now().microsecondsSinceEpoch,
    );

    if (!isError) {
      _timer = Timer(_autoDismiss, close);
    }
  }
}

class _AppToastPayload {
  const _AppToastPayload({
    required this.message,
    required this.style,
    required this.showClose,
    required this.token,
  });

  final String message;
  final AppToastStyle style;
  final bool showClose;
  final int token;
}

/// Renders [AppToast] at the bottom of the root app stack.
class AppToastHost extends StatelessWidget {
  const AppToastHost({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final payload = AppToast._payload.value;
      if (payload == null) return const SizedBox.shrink();

      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: AppToastBar(
          key: ValueKey('app-toast-${payload.token}'),
          message: payload.message,
          style: payload.style,
          showClose: payload.showClose,
          onClose: AppToast.close,
        ),
      );
    });
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

/// Full-width bottom bar with message (and close only for sticky errors).
class AppToastBar extends StatelessWidget {
  const AppToastBar({
    super.key,
    required this.message,
    required this.style,
    this.showClose = false,
    this.onClose,
  });

  final String message;
  final AppToastStyle style;
  final bool showClose;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppToastColors.background(style);
    final foregroundColor = AppToastColors.foreground(style);
    final textStyle = AppTextStyles.labelText(context).copyWith(
      color: foregroundColor,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none,
    );

    final bar = Material(
      color: backgroundColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.symmetric(context, v: 0.005, h: 0.04),
          child: showClose
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        textAlign: TextAlign.start,
                        style: textStyle,
                      ),
                    ),
                    AppSpacing.horizontal(context, 0.02),
                    AppIconButton(
                      onTap: onClose,
                      icon: AppIcons.close,
                      backgroundColor: AppColors.white,
                      iconColor: AppColors.black,
                      iconSize: AppResponsive.iconSize(context) * 0.9,
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                ),
        ),
      ),
    );

    return Dismissible(
      key: ValueKey('toast-${style.name}-$message'),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => onClose?.call(),
      child: bar,
    );
  }
}
