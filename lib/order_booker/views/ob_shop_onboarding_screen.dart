import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/shops/register/ob_register_shop_form.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shop_onboarding_controller.dart';

class ObShopOnboardingScreen extends GetView<ObShopOnboardingController> {
  const ObShopOnboardingScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    final content = _ShopFormContent(controller: controller);

    if (embeddedInShell) return content;

    return AppSubScreenScaffold(title: controller.screenTitle, body: content);
  }
}

class _ShopFormContent extends StatelessWidget {
  const _ShopFormContent({required this.controller});

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

            if (controller.loadError.value != null) {
              return AppEmptyState(
                title: AppTexts.emptyLoadFailedTitle,
                subtitle: controller.loadError.value!,
                image: AppImages.emptyError,
                onRefresh: () => controller.onPullToRefresh(),
              );
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
                label: controller.submitLabel,
                icon: controller.isEditing ? AppIcons.edit : AppIcons.userAdd,
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
