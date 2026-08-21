import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_collection_snapshot_strip.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_collection_target_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_dashboard_greeting.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_pickup_status_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_recent_collections_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_stock_items_section.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_today_summary_cards.dart';

class DmDashboardScreen extends GetView<DmDashboardController> {
  const DmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return AppShimmerSkeletons.dashboard(context);
        }

        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            children: [
              DmDashboardGreeting(
                greeting: controller.greeting,
                userName: controller.userName,
              ),
              AppSpacing.vertical(context, 0.02),
              AppSectionHeader(
                title: AppTexts.dmTodaySummary,
                bottomSpacing: true,
              ),
              DmTodaySummaryCards(
                pendingCount: controller.pendingCount.value,
                inTransitCount: controller.inTransitCount.value,
                deliveredCount: controller.deliveredCount.value,
              ),
              AppSpacing.vertical(context, 0.02),
              DmPickupStatusCard(
                pickupConfirmed: controller.pickupConfirmed.value,
                onGoToPickup: controller.goToPickup,
                onContinueDeliveries: controller.goToOrders,
              ),
              AppSpacing.vertical(context, 0.02),
              AppSectionHeader(
                title: AppTexts.dmStockOnHandTitle,
                bottomSpacing: true,
              ),
              DmStockItemsSection(
                items: controller.stockItems.toList(growable: false),
                loadedCount: controller.loadedStockCount,
                onHandCount: controller.onHandStockCount,
              ),
              AppSpacing.vertical(context, 0.02),
              AppSectionHeader(
                title: AppTexts.navCollections,
                bottomSpacing: true,
              ),
              DmCollectionSnapshotStrip(
                collectedToday: controller.collectedToday.value,
                stillDue: controller.stillDue.value,
                cashInBag: controller.cashInBag.value,
                onCollectedTap: controller.goToCollectionHistory,
                onStillDueTap: controller.goToTodayShops,
                onCashInBagTap: controller.goToHandover,
              ),
              AppSpacing.vertical(context, 0.02),
              AppSectionHeader(title: AppTexts.dmTargets),
              AppSpacing.vertical(context, 0.01),
              DmCollectionTargetCard(targets: controller.targets.value),
              AppSpacing.vertical(context, 0.01),
              AppSectionHeader(
                title: AppTexts.dmRecentCollections,
                onViewAll: controller.goToCollectionHistory,
              ),
              if (controller.recentCollections.isEmpty)
                AppEmptyState(
                  title: AppTexts.emptyNoCollectionsTitle,
                  subtitle: AppTexts.dmNoRecentCollections,
                  image: AppImages.emptyNoCollections,
                )
              else
                DmRecentCollectionsCard(
                  collections: controller.recentCollections.toList(
                    growable: false,
                  ),
                  onCollectionTap: controller.openCollection,
                ),
            ],
          ),
        );
      }),
    );
  }
}
