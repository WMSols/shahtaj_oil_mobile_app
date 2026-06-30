import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/onboarding_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/onboarding/onboarding_progress_bar.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/onboarding/onboarding_step_actions.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/onboarding/onboarding_step_content.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => OnboardingProgressBar(
                  pageCount: OnboardingController.pageCount,
                  currentPage: controller.currentPage.value,
                ),
              ),
              AppSpacing.vertical(context, 0.04),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: OnboardingController.pageCount,
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: OnboardingStepContent(
                          title: OnboardingController.titleFor(index),
                          body: OnboardingController.bodyFor(index),
                          illustration:
                              OnboardingController.illustrations[index],
                        ),
                      ),
                      AppSpacing.vertical(context, 0.03),
                      OnboardingStepActions(stepIndex: index),
                      AppSpacing.vertical(context, 0.01),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
