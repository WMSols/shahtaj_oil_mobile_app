import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class AppCopyrightFooter extends StatelessWidget {
  const AppCopyrightFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: AppTextStyles.caption(context),
        children: [
          TextSpan(text: AppTexts.copyrightsPrefix),
          TextSpan(
            text: AppTexts.brandName,
            style: AppTextStyles.caption(context).copyWith(
              color: AppColors.primary,
            ),
          ),
          TextSpan(text: ' ${DateTime.now().year}'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
