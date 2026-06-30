import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class OnboardingStepContent extends StatelessWidget {
  const OnboardingStepContent({
    super.key,
    required this.title,
    required this.body,
    required this.illustration,
  });

  final String title;
  final String body;
  final String illustration;

  @override
  Widget build(BuildContext context) {
    final imageSize = AppResponsive.screenWidth(context) * 0.72;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.headline(context)),
        AppSpacing.vertical(context, 0.03),
        Expanded(
          child: Center(
            child: Image.asset(
              illustration,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(body, style: AppTextStyles.bodyText(context)),
      ],
    );
  }
}
