import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class AppKeyValueRow extends StatelessWidget {
  const AppKeyValueRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSpacing.verticalValue(context, 0.005),
      ),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.caption(context),
          children: [
            TextSpan(
              text: AppTexts.keyValue(label, ''),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
