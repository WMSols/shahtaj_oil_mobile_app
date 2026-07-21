import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';

enum AppStatusStripeEdge { left, bottom }

/// Status indicator used inside outline / list cards.
class AppStatusStripe extends StatelessWidget {
  const AppStatusStripe({
    super.key,
    required this.color,
    this.edge = AppStatusStripeEdge.left,
    this.thicknessFactor = 0.012,
  });

  final Color color;
  final AppStatusStripeEdge edge;

  /// Fraction of screen width (left) or height (bottom) used for thickness.
  final double thicknessFactor;

  @override
  Widget build(BuildContext context) {
    if (edge == AppStatusStripeEdge.bottom) {
      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          height: AppSpacing.verticalValue(context, thicknessFactor),
          color: color,
        ),
      );
    }

    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: AppSpacing.horizontalValue(context, thicknessFactor),
        color: color,
      ),
    );
  }
}
