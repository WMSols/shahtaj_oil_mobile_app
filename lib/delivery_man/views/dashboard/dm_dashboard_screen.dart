import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dashboard/dm_recent_activity_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_dashboard_greeting.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_next_action_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_next_stop_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_recent_activity_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_stock_items_section.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_targets_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_today_snapshot_strip.dart';

class DmDashboardScreen extends GetView<DmDashboardController> {
  const DmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value && !controller.hasContent) {
          return AppShimmerSkeletons.dashboard(context);
        }

        if (controller.error.value != null && !controller.hasContent) {
          return AppEmptyState(
            title: AppTexts.emptyLoadFailedTitle,
            subtitle: controller.error.value!,
            image: AppImages.emptyError,
            onRefresh: controller.load,
          );
        }

        final action = controller.nextAction;
        final nextOrder = controller.nextOrder.value;
        final nextShop = controller.nextDueShop.value;
        final targets = controller.targets.value;

        final content = RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            children: [
              DmDashboardGreeting(
                greeting: controller.greeting,
                userName: controller.userName,
              ),
              if (action != null) ...[
                AppSpacing.vertical(context, 0.016),
                DmNextActionCard(
                  action: action,
                  onPressed: controller.runNextAction,
                ),
              ],
              AppSpacing.vertical(context, 0.016),
              DmTodaySnapshotStrip(
                pendingCount: controller.pendingCount.value,
                inTransitCount: controller.inTransitCount.value,
                deliveredCount: controller.deliveredCount.value,
                collectedToday: controller.collectedToday.value,
                stillDue: controller.stillDue.value,
                cashInBag: controller.cashInBag.value,
                shopsDueCount: controller.shopsDueCount.value,
                onPendingTap: controller.goToOrders,
                onInTransitTap: controller.goToDeliver,
                onDeliveredTap: controller.goToDeliveriesList,
                onCollectedTap: controller.goToCollectionHistory,
                onStillDueTap: controller.goToTodayShops,
                onCashInBagTap: controller.goToHandover,
              ),
              if (controller.showNextDeliveryStop && nextOrder != null) ...[
                AppSpacing.vertical(context, 0.02),
                AppSectionHeader(
                  title: AppTexts.dmNextStopDelivery,
                  bottomSpacing: true,
                ),
                DmNextStopCard(
                  title: nextOrder.shopName,
                  amount: AppFormatter.currency(
                    nextOrder.resolvedTotal,
                    symbol: 'Rs. ',
                  ),
                  onOpen: controller.openNextOrder,
                ),
              ],
              if (controller.showNextCollectionStop && nextShop != null) ...[
                AppSpacing.vertical(context, 0.02),
                AppSectionHeader(
                  title: AppTexts.dmNextStopCollection,
                  bottomSpacing: true,
                ),
                DmNextStopCard(
                  title: nextShop.name,
                  amount: AppFormatter.currency(
                    nextShop.outstanding,
                    symbol: 'Rs. ',
                  ),
                  statusColor: AppColors.warning,
                  onOpen: controller.openNextDueShop,
                ),
              ],
              AppSpacing.vertical(context, 0.02),
              AppSectionHeader(title: AppTexts.dmTargets),
              AppSpacing.vertical(context, 0.01),
              if (!targets.hasAnyTarget)
                AppEmptyState(
                  title: AppTexts.emptyNoTargetsTitle,
                  subtitle: AppTexts.dmTargetsNoneSubtitle,
                  image: AppImages.empty,
                )
              else
                DmTargetsCard(
                  targets: targets,
                  onDeliveryTap: controller.goToDeliveriesList,
                  onRecoveryTap: controller.goToCollectionHistory,
                ),
              AppSpacing.vertical(context, 0.02),
              AppSectionHeader(
                title: AppTexts.dmStockOnHandTitle,
                onViewAll: controller.goToVanStock,
                bottomSpacing: true,
              ),
              if (controller.stockItems.isEmpty)
                AppEmptyState(
                  title: AppTexts.emptyNoStockTitle,
                  subtitle: AppTexts.dmStockEmptySubtitle,
                  image: AppImages.emptyNoStock,
                )
              else
                DmStockItemsSection(
                  items: controller.stockItems.toList(growable: false),
                ),
              AppSpacing.vertical(context, 0.02),
              AppSectionHeader(
                title: AppTexts.dmRecentActivity,
                onViewAll:
                    controller.recentActivity.length >
                        DmDashboardController.recentPreviewLimit
                    ? () => Get.to(() => const DmRecentActivityScreen())
                    : null,
              ),
              if (controller.recentActivity.isEmpty)
                AppEmptyState(
                  title: AppTexts.emptyNoCollectionsTitle,
                  subtitle: AppTexts.dmNoRecentActivity,
                  image: AppImages.emptyNoCollections,
                )
              else
                DmRecentActivityCard(
                  items: controller.previewRecentActivity,
                  onItemTap: controller.openActivity,
                ),
            ],
          ),
        );

        if (!controller.isRefreshing.value) return content;
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
