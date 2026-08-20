import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/dashboard/rm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/dashboard/rm_dashboard_greeting.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/dashboard/rm_recent_collections_card.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/dashboard/rm_recovery_target_card.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/dashboard/rm_today_snapshot_strip.dart';

class RmDashboardScreen extends GetView<RmDashboardController> {
  const RmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.dashboard.value == null) {
          return AppShimmerSkeletons.dashboard(context);
        }

        if (controller.error.value != null) {
          return AppEmptyState(
            title: AppTexts.emptyLoadFailedTitle,
            subtitle: controller.error.value!,
            image: AppImages.emptyError,
            onRefresh: () => controller.loadDashboard(force: true),
          );
        }

        final content = RefreshIndicator(
          onRefresh: () => controller.loadDashboard(force: true),
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            children: [
              RmDashboardGreeting(
                greeting: controller.greeting,
                userName: controller.userName,
              ),
              AppSpacing.vertical(context, 0.016),
              RmTodaySnapshotStrip(
                collectedToday: controller.collectedToday,
                stillDue: controller.stillDue,
                cashInBag: controller.cashInBag,
                onCollectedTap: controller.goToHistory,
                onStillDueTap: controller.goToTodayShops,
                onCashInBagTap: controller.goToHandover,
              ),
              AppSpacing.vertical(context, 0.02),
              AppSectionHeader(title: AppTexts.rmTargets),
              AppSpacing.vertical(context, 0.01),
              RmRecoveryTargetCard(targets: controller.targets),
              AppSpacing.vertical(context, 0.01),
              AppSectionHeader(
                title: AppTexts.rmRecentCollections,
                onViewAll: controller.goToHistory,
              ),
              if (controller.recentCollections.isEmpty)
                AppEmptyState(
                  title: AppTexts.emptyNoCollectionsTitle,
                  subtitle: AppTexts.rmNoRecentCollections,
                  image: AppImages.emptyNoCollections,
                )
              else
                RmRecentCollectionsCard(
                  collections: controller.recentCollections,
                  onCollectionTap: controller.openCollection,
                ),
            ],
          ),
        );

        if (!controller.isLoading.value) return content;
        return Stack(
          children: [
            content,
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                minHeight: 2,
                color: AppColors.primary,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        );
      }),
    );
  }
}
