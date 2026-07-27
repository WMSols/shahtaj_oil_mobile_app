import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';

/// Shared English / Urdu selector used by onboarding and account screens.
class AppLanguageToggle extends StatelessWidget {
  const AppLanguageToggle({
    super.key,
    required this.isEnglishSelected,
    required this.onEnglishPressed,
    required this.onUrduPressed,
  });

  final bool isEnglishSelected;
  final VoidCallback onEnglishPressed;
  final VoidCallback onUrduPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: isEnglishSelected
              ? AppPrimaryButton(
                  label: AppTexts.languageEnglishButton,
                  labelStyle: AppTextStyles.languagePickerButtonText(
                    context,
                    urdu: false,
                  ),
                  onPressed: onEnglishPressed,
                )
              : AppSecondaryButton(
                  label: AppTexts.languageEnglishButton,
                  labelStyle: AppTextStyles.languagePickerButtonText(
                    context,
                    urdu: false,
                  ),
                  onPressed: onEnglishPressed,
                ),
        ),
        AppSpacing.horizontal(context, 0.02),
        Expanded(
          child: !isEnglishSelected
              ? AppPrimaryButton(
                  label: AppTexts.languageUrduButton,
                  labelStyle: AppTextStyles.languagePickerButtonText(
                    context,
                    urdu: true,
                  ),
                  onPressed: onUrduPressed,
                )
              : AppSecondaryButton(
                  label: AppTexts.languageUrduButton,
                  labelStyle: AppTextStyles.languagePickerButtonText(
                    context,
                    urdu: true,
                  ),
                  onPressed: onUrduPressed,
                ),
        ),
      ],
    );
  }
}
