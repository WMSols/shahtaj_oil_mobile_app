import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppInfoInlineField extends StatelessWidget {
  const AppInfoInlineField({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyText(
          context,
        ).copyWith(fontSize: AppResponsive.scaleSize(context, 11)),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          TextSpan(
            text: ' $value',
            style: const TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
