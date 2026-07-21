import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_status_stripe.dart';

class AppOutlineCard extends StatelessWidget {
  const AppOutlineCard({
    super.key,
    required this.child,
    this.padding,
    this.color = AppColors.white,
    this.borderColor = AppColors.cardBorder,
    this.clipBehavior = Clip.antiAlias,
    this.statusColor,
    this.statusStripeEdge = AppStatusStripeEdge.left,
    this.statusStripeThicknessFactor = 0.008,
    this.onTap,
    this.width,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final Color borderColor;
  final Clip clipBehavior;
  final Color? statusColor;
  final AppStatusStripeEdge statusStripeEdge;
  final double statusStripeThicknessFactor;
  final VoidCallback? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppResponsive.radius(context));
    final resolvedPadding =
        padding ?? AppSpacing.symmetric(context, h: 0.02, v: 0.02);

    final body = statusColor == null
        ? Padding(padding: resolvedPadding, child: child)
        : Stack(
            children: [
              AppStatusStripe(
                color: statusColor!,
                edge: statusStripeEdge,
                thicknessFactor: statusStripeThicknessFactor,
              ),
              Padding(padding: resolvedPadding, child: child),
            ],
          );

    if (onTap == null) {
      return Container(
        width: width,
        clipBehavior: clipBehavior,
        decoration: BoxDecoration(
          color: color,
          borderRadius: radius,
          border: Border.all(color: borderColor),
        ),
        child: body,
      );
    }

    return Material(
      color: color,
      borderRadius: radius,
      clipBehavior: clipBehavior,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          width: width,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: borderColor),
          ),
          child: body,
        ),
      ),
    );
  }
}
