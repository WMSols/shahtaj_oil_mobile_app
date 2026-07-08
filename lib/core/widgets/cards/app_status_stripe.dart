import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';

/// Left-edge status indicator used inside outline / list cards.
class AppStatusStripe extends StatelessWidget {
  const AppStatusStripe({
    super.key,
    required this.color,
    this.widthFactor = 0.012,
  });

  final Color color;

  /// Fraction of screen width used for stripe thickness.
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: AppSpacing.horizontalValue(context, widthFactor),
        color: color,
      ),
    );
  }
}
