import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/onboarding_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_language_toggle.dart';

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
      return AppLanguageToggle(
        isEnglishSelected: controller.isEnglishSelected.value,
        onEnglishPressed: controller.selectEnglish,
        onUrduPressed: controller.selectUrdu,
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
