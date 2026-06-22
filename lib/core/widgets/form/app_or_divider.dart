import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class AppOrDivider extends StatelessWidget {
  const AppOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.cardBorder)),
        Padding(
          padding: AppSpacing.symmetric(context, h: 0.03, v: 0),
          child: Text(AppTexts.or, style: AppTextStyles.caption(context)),
        ),
        const Expanded(child: Divider(color: AppColors.cardBorder)),
      ],
    );
  }
}
