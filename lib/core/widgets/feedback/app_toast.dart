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

/// Top feedback bar hosted in the app [Stack] (see [AppTopFeedbackOverlay]).
///
/// Not backed by GetX snackbars — those caused [LateInitializationError] when
/// closing sticky errors or navigating with [Get.back].
abstract class AppToast {
  AppToast._();

  static const Duration autoDismiss = Duration(seconds: 3);
  static const Duration slideDuration = Duration(milliseconds: 500);

  static final Rxn<_AppToastPayload> _payload = Rxn<_AppToastPayload>();
  static final RxInt _overlayEpoch = 0.obs;
  static Timer? _timer;
  static bool _isExiting = false;

  /// Bumped whenever toast visibility changes — observe in [AppTopFeedbackOverlay].
  static int get overlayEpoch => _overlayEpoch.value;

  static bool get hasToast => _payload.value != null;
  static bool get isExiting => _isExiting;
  static bool get isVisible => hasToast && !_isExiting;

  static String get toastMessage => _payload.value?.message ?? '';
  static AppToastStyle get toastStyle =>
      _payload.value?.style ?? AppToastStyle.neutral;
  static bool get toastShowClose => _payload.value?.showClose ?? false;
  static int get toastToken => _payload.value?.token ?? 0;

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

  /// Starts slide-out; clears after [completeClose].
  static void close() {
    _timer?.cancel();
    _timer = null;
    if (_payload.value == null || _isExiting) return;
    _isExiting = true;
    _overlayEpoch.value++;
  }

  /// Clears toast after slide-out (or immediate swipe dismiss).
  static void completeClose() {
    _timer?.cancel();
    _timer = null;
    _payload.value = null;
    _isExiting = false;
    _overlayEpoch.value++;
  }

  static void _show({required AppToastStatus status, required String message}) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    _timer?.cancel();
    _timer = null;
    _isExiting = false;

    final style = _styleFor(status);
    final isError = status == AppToastStatus.error;

    _payload.value = _AppToastPayload(
      message: trimmed,
      style: style,
      showClose: isError,
      // Bust identical consecutive messages so Obx/Dismissible remount.
      token: DateTime.now().microsecondsSinceEpoch,
    );
    _overlayEpoch.value++;

    if (!isError) {
      _timer = Timer(autoDismiss, close);
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

/// Visual variants for toast and system status bars.
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

/// Slides [child] in from the top when [visible] becomes true, and out to the
/// top when it becomes false. Collapses height with the same animation.
class AppSlideInBar extends StatefulWidget {
  const AppSlideInBar({
    super.key,
    required this.visible,
    required this.child,
    this.onExitComplete,
    this.duration = AppToast.slideDuration,
  });

  final bool visible;
  final Widget child;
  final VoidCallback? onExitComplete;
  final Duration duration;

  @override
  State<AppSlideInBar> createState() => _AppSlideInBarState();
}

class _AppSlideInBarState extends State<AppSlideInBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _size;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(curved);
    _size = curved;

    if (widget.visible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.visible) {
          _controller.forward(from: 0);
        }
      });
    }
  }

  @override
  void didUpdateWidget(AppSlideInBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.visible == oldWidget.visible) return;

    if (widget.visible) {
      _controller.forward(from: _controller.value);
    } else {
      _controller.reverse().whenComplete(() {
        if (!mounted || widget.visible) return;
        widget.onExitComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SlideTransition(
        position: _slide,
        child: SizeTransition(
          sizeFactor: _size,
          axis: Axis.vertical,
          alignment: Alignment.topCenter,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Full-width top bar with message (and close only for sticky errors).
///
/// Does not pad for the status bar — wrap a stack of bars in [SafeArea]
/// (see [AppTopFeedbackOverlay]) so color does not bleed into the system bar.
class AppToastBar extends StatelessWidget {
  const AppToastBar({
    super.key,
    required this.message,
    required this.style,
    this.showClose = false,
    this.onClose,
    this.onSwipeDismissed,
  });

  final String message;
  final AppToastStyle style;
  final bool showClose;
  final VoidCallback? onClose;
  final VoidCallback? onSwipeDismissed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppToastColors.background(style);
    final foregroundColor = AppToastColors.foreground(style);
    final textStyle = AppTextStyles.labelText(context).copyWith(
      color: foregroundColor,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none,
    );

    final content = Padding(
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
    );

    // Only allow swipe-to-dismiss when a handler is wired up. Without one the
    // Dismissible would remove itself from the tree but the parent would never
    // stop building it, causing the "dismissed Dismissible still in tree" error.
    final dismissHandler = onSwipeDismissed ?? onClose;
    return Dismissible(
      key: ValueKey('toast-${style.name}-$message'),
      direction: dismissHandler != null
          ? DismissDirection.horizontal
          : DismissDirection.none,
      onDismissed: dismissHandler != null ? (_) => dismissHandler() : null,
      child: Material(color: backgroundColor, child: content),
    );
  }
}
