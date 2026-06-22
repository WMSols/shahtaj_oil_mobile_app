import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppAuthFieldLabel extends StatelessWidget {
  const AppAuthFieldLabel({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.verticalValue(context, 0.008)),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppResponsive.scaleSize(context, 18),
            color: AppColors.textPrimary,
          ),
          AppSpacing.horizontal(context, 0.02),
          Text(label, style: AppTextStyles.labelText(context)),
        ],
      ),
    );
  }
}
