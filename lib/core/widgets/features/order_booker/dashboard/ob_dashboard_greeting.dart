import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class ObDashboardGreeting extends StatelessWidget {
  const ObDashboardGreeting({
    super.key,
    required this.greeting,
    required this.userName,
  });

  final String greeting;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTextStyles.bodyText(
            context,
          ).copyWith(color: AppColors.grey),
        ),
        Text(
          AppTexts.homeGreetingHey(userName),
          style: AppTextStyles.heading(context),
        ),
        Text(
          AppTexts.obDashboardSubtitle,
          style: AppTextStyles.bodyText(
            context,
          ).copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}
