import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/account_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/account/account_details_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/account/account_language_toggle_section.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/account/account_profile_header.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionService>();

    return AppScaffold(
      body: Obx(() {
        final user = session.user.value;
        final role = session.role.value ?? user?.role;
        final connectivity = Get.find<ConnectivityService>();
        final presence = !connectivity.isOnline.value
            ? PresenceStatus.offline
            : (user?.presenceStatus ?? PresenceStatus.away);

        if (controller.isLoading.value && user == null) {
          return const AppLoader();
        }

        if (user == null || role == null) {
          return AppEmptyState(
            title: AppTexts.emptyProfileTitle,
            subtitle:
                controller.loadError.value ?? AppTexts.emptyLoadFailedSubtitle,
            image: AppImages.emptyError,
            actionLabel: AppTexts.retry,
            onAction: () => controller.loadProfile(force: true),
            onRefresh: () => controller.loadProfile(force: true),
          );
        }

        final profileUser = user;
        final profileRole = role;

        return RefreshIndicator(
          onRefresh: () => controller.loadProfile(force: true),
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              AccountProfileHeader(
                user: profileUser,
                role: profileRole,
                presenceStatus: presence,
              ),
              AppSpacing.vertical(context, 0.025),
              AppSectionHeader(
                title: AppTexts.accountDetails,
                bottomSpacing: true,
              ),
              AccountDetailsCard(user: profileUser, role: profileRole),
              AppSpacing.vertical(context, 0.025),
              AppSectionHeader(
                title: AppTexts.changeLanguage,
                bottomSpacing: true,
              ),
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
