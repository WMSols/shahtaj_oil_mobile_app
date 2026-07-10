import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/account_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/account/account_details_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/account/account_language_toggle_section.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/account/account_profile_header.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/account/account_section_header.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionService>();

    return AppScaffold(
      body: Obx(() {
        final user = session.user.value;
        final role = session.role.value ?? user?.role;

        if (controller.isLoading.value && user == null) {
          return const AppLoader();
        }

        if (user == null || role == null) {
          return AppEmptyState(
            title: AppTexts.myProfile,
            subtitle: controller.loadError.value ?? AppTexts.error,
            actionLabel: AppTexts.retry,
            onAction: controller.loadProfile,
          );
        }

        final profileUser = user;
        final profileRole = role;

        return RefreshIndicator(
          onRefresh: controller.loadProfile,
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              AccountProfileHeader(user: profileUser, role: profileRole),
              AppSpacing.vertical(context, 0.025),
              AccountSectionHeader(title: AppTexts.accountDetails),
              AccountDetailsCard(user: profileUser, role: profileRole),
              AppSpacing.vertical(context, 0.025),
              AccountSectionHeader(title: AppTexts.changeLanguage),
              const AccountLanguageToggleSection(),
              AppSpacing.vertical(context, 0.025),
              AppPrimaryButton(
                label: AppTexts.logout,
                isLoading: controller.isLoggingOut.value,
                onPressed: controller.logout,
              ),
              AppSpacing.vertical(context, 0.01),
            ],
          ),
        );
      }),
    );
  }
}
