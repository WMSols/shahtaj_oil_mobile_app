import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';

/// Shared shimmer primitives for OB / DM / RM cold loads.
///
/// Wrap a skeleton tree once with [AppShimmer]; use [box]/[line]/[circle]/
/// [chip]/[listCard] as plain bones inside that tree.
class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  static Widget box({
    double? width,
    double? height,
    double? radius,
    BorderRadius? borderRadius,
  }) {
    return _ShimmerBone(
      width: width,
      height: height,
      borderRadius: borderRadius,
      radius: radius,
    );
  }

  static Widget line({
    double widthFactor = 1,
    double height = 12,
    double? radius,
  }) {
    return FractionallySizedBox(
      widthFactor: widthFactor.clamp(0.1, 1),
      alignment: Alignment.centerLeft,
      child: _ShimmerBone(height: height, radius: radius ?? 6),
    );
  }

  static Widget circle({double size = 28}) {
    return _ShimmerBone(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size),
    );
  }

  static Widget chip({double width = 64, double height = 22}) {
    return _ShimmerBone(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(height),
    );
  }

  /// Outline-card shaped list row used across roles.
  static Widget listCard(BuildContext context, {Widget? child}) {
    final radius = AppResponsive.radius(context);
    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child:
          child ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppShimmer.line(widthFactor: 0.55, height: 14),
                  ),
                  AppShimmer.chip(),
                ],
              ),
              SizedBox(height: AppSpacing.verticalValue(context, 0.01)),
              AppShimmer.line(widthFactor: 0.4, height: 11),
              SizedBox(height: AppSpacing.verticalValue(context, 0.008)),
              AppShimmer.line(widthFactor: 0.7, height: 11),
            ],
          ),
    );
  }

  static Widget list({
    required BuildContext context,
    int count = 5,
    Widget Function(BuildContext context, int index)? itemBuilder,
  }) {
    return Column(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.verticalValue(context, 0.01)),
          itemBuilder?.call(context, i) ?? AppShimmer.listCard(context),
        ],
      ],
    );
  }

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        // Light ↔ dim pulse (grey only — no horizontal sweep / primary tint).
        final t = _pulse.value;
        final opacity = 0.42 + (t * 0.58);
        return Opacity(opacity: opacity, child: child);
      },
      child: widget.child,
    );
  }
}

class _ShimmerBone extends StatelessWidget {
  const _ShimmerBone({this.width, this.height, this.radius, this.borderRadius});

  final double? width;
  final double? height;
  final double? radius;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final r =
        borderRadius ??
        BorderRadius.circular(radius ?? AppResponsive.radius(context) * 0.5);
    return Container(
      width: width ?? double.infinity,
      height: height ?? 12,
      decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: r),
    );
  }
}
