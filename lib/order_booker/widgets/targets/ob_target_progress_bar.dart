import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';

class ObTargetProgressBar extends StatelessWidget {
  const ObTargetProgressBar({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
      child: LinearProgressIndicator(
        minHeight: AppSpacing.verticalValue(context, 0.005),
        value: value.clamp(0, 1),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
      ),
    );
  }
}
