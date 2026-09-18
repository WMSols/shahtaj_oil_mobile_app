import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_dashboard_greeting.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_next_action_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_next_stop_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_stock_items_section.dart';
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
        final nextJob = controller.nextJob.value;
        final session = controller.sessionState.value;

        final content = RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            children: [
              DmDashboardGreeting(
                greeting: controller.greeting,
                userName: controller.userName,
              ),
              if (session != null) ...[
                AppSpacing.vertical(context, 0.01),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppStatusChip(
                    label: session.label,
                    color: session.chipColor,
                  ),
                ),
              ],
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
                walletBalance: controller.walletBalance.value,
                settledTotal: controller.settledTotal.value,
                onPendingTap: controller.goToOrders,
                onInTransitTap: controller.goToOrders,
                onDeliveredTap: controller.goToOrders,
                onCollectedTap: controller.goToCollectionHistory,
                onWalletTap: controller.goToWallet,
                onSettledTap: controller.goToWallet,
              ),
              if (controller.showNextDeliveryStop && nextJob != null) ...[
                AppSpacing.vertical(context, 0.02),
                AppSectionHeader(
                  title: AppTexts.dmNextStopDelivery,
                  bottomSpacing: true,
                ),
                DmNextStopCard(
                  title: nextJob.shopName,
                  amount: nextJob.shopAddress?.isNotEmpty == true
                      ? nextJob.shopAddress!
                      : nextJob.fieldState.label,
                  onOpen: controller.openNextJob,
                ),
              ],
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
