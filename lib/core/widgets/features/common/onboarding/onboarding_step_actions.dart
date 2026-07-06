import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/onboarding_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';

class OnboardingStepActions extends GetView<OnboardingController> {
  const OnboardingStepActions({super.key, required this.stepIndex});

  final int stepIndex;

  @override
  Widget build(BuildContext context) => switch (stepIndex) {
    0 => AppPrimaryButton(
      label: AppTexts.getStarted,
      onPressed: controller.goToNextPage,
    ),
    1 => Obx(() {
      final isEnglish = controller.isEnglishSelected.value;
      return Row(
        children: [
          Expanded(
            child: isEnglish
                ? AppPrimaryButton(
                    label: AppTexts.languageEnglishButton,
                    labelStyle: AppTextStyles.languagePickerButtonText(
                      context,
                      urdu: false,
                    ),
                    onPressed: controller.selectEnglish,
                  )
                : AppSecondaryButton(
                    label: AppTexts.languageEnglishButton,
                    labelStyle: AppTextStyles.languagePickerButtonText(
                      context,
                      urdu: false,
                    ),
                    onPressed: controller.selectEnglish,
                  ),
          ),
          AppSpacing.horizontal(context, 0.02),
          Expanded(
            child: !isEnglish
                ? AppPrimaryButton(
                    label: AppTexts.languageUrduButton,
                    labelStyle: AppTextStyles.languagePickerButtonText(
                      context,
                      urdu: true,
                    ),
                    onPressed: controller.selectUrdu,
                  )
                : AppSecondaryButton(
                    label: AppTexts.languageUrduButton,
                    labelStyle: AppTextStyles.languagePickerButtonText(
                      context,
                      urdu: true,
                    ),
                    onPressed: controller.selectUrdu,
                  ),
          ),
        ],
      );
    }),
    _ => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: UserRole.values.map((role) {
        final isLast = role == UserRole.values.last;
        return Padding(
          padding: EdgeInsets.only(
            bottom: isLast ? 0 : AppSpacing.verticalValue(context, 0.01),
          ),
          child: AppSecondaryButton(
            label: role.label,
            onPressed: () => controller.selectRole(role),
          ),
        );
      }).toList(),
    ),
  };
}
