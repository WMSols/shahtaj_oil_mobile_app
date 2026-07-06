import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/shops/register/ob_register_shop_form.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shop_onboarding_controller.dart';

class ObShopOnboardingScreen extends GetView<ObShopOnboardingController> {
  const ObShopOnboardingScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    final content = _RegisterShopContent(controller: controller);

    if (embeddedInShell) return content;

    return AppSubScreenScaffold(
      title: AppTexts.obShopOnboardingTitle,
      body: content,
    );
  }
}

class _RegisterShopContent extends StatelessWidget {
  const _RegisterShopContent({required this.controller});

  final ObShopOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.isLoadingOptions.value) {
              return const AppLoader();
            }

            return RefreshIndicator(
              onRefresh: controller.onPullToRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppSpacing.screenPadding(context).copyWith(bottom: 0),
                child: ObRegisterShopForm(controller: controller),
              ),
            );
          }),
        ),
        SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding(context).copyWith(top: 0),
            child: Obx(
              () => AppPrimaryButton(
                label: AppTexts.obRegisterShopButton,
                icon: AppIcons.userAdd,
                isLoading: controller.isSubmitting.value,
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.submit,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
