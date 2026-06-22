import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class AppInfoDescriptionBox extends StatelessWidget {
  const AppInfoDescriptionBox({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all(context, factor: 1.5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 1),
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodyText(
            context,
          ).copyWith(fontSize: AppResponsive.scaleSize(context, 12)),
          children: [
            TextSpan(
              text: '${AppTexts.desc} :',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.grey,
              ),
            ),
            TextSpan(
              text: ' $description',
              style: const TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
