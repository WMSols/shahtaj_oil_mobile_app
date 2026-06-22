import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppScreenTitleDivider extends StatelessWidget {
  const AppScreenTitleDivider({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.screenTitle(context)),
        AppSpacing.vertical(context, 0.015),
        const Divider(color: AppColors.cardBorder, height: 1),
      ],
    );
  }
}
