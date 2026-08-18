import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/dashboard/ob_dashboard_greeting.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/dashboard/ob_orders_target_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/dashboard/ob_recent_orders_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/dashboard/ob_route_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/dashboard/ob_today_snapshot_strip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/tasks/ob_active_visit_banner.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/dashboard/ob_dashboard_controller.dart';

class ObDashboardScreen extends GetView<ObDashboardController> {
  const ObDashboardScreen({super.key});

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

        final route = controller.todaysRoute;

        final content = RefreshIndicator(
          onRefresh: () => controller.loadDashboard(force: true),
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            children: [
              ObDashboardGreeting(
                greeting: controller.greeting,
                userName: controller.userName,
              ),
              if (controller.activeVisit.value != null) ...[
                AppSpacing.vertical(context, 0.012),
                ObActiveVisitBanner(
                  visit: controller.activeVisit.value!,
                  onResume: controller.resumeActiveVisit,
                ),
              ],
              AppSpacing.vertical(context, 0.016),
              ObTodaySnapshotStrip(
                completed: controller.completedTasks,
                pending: controller.pendingTasks,
                ordersCount: controller.ordersTodayCount,
                ordersValue: controller.ordersTodayValue,
                onVisitedTap: () =>
                    controller.goToRouteDetail(filter: TaskStatus.completed),
                onPendingTap: () =>
                    controller.goToRouteDetail(filter: TaskStatus.pending),
                onOrdersTap: () => controller.goToOrderHistory(
                  outcome: VisitOutcome.orderPlaced,
                ),
              ),
              AppSpacing.vertical(context, 0.02),
              AppSectionHeader(
                title: AppTexts.obTodaysRoute,
                onViewAll: controller.goToRouteDetail,
              ),
              if (route == null)
                AppEmptyState(
                  title: AppTexts.emptyNoRouteTitle,
                  subtitle: AppTexts.obNoRouteAssigned,
                  image: AppImages.emptyNoRoute,
                )
              else
                ObRouteCard(
                  route: route,
                  onTap: controller.goToRouteDetail,
                  onActionTap: controller.onRouteAction,
                  completedTasks: controller.completedTasks,
                  totalTasks: controller.totalTasks,
                ),
              AppSpacing.vertical(context, 0.01),
              AppSectionHeader(
                title: AppTexts.obTargets,
                onViewAll: controller.goToTargets,
              ),
              if (controller.targets.topHighlights.isEmpty)
                AppEmptyState(
                  title: AppTexts.emptyNoTargetsTitle,
                  subtitle: AppTexts.obTargetsDashboardSummary,
                  image: AppImages.emptyNoTargets,
                )
              else
                ObOrdersTargetCard(
                  targets: controller.targets,
                  onTap: controller.goToTargets,
                ),
              AppSpacing.vertical(context, 0.01),
              AppSectionHeader(
                title: AppTexts.obRecentOrders,
                onViewAll: controller.goToOrderHistory,
              ),
              if (controller.recentOrders.isEmpty)
                AppEmptyState(
                  title: AppTexts.emptyNoOrdersTitle,
                  subtitle: AppTexts.obNoRecentOrders,
                  image: AppImages.emptyNoOrders,
                )
              else
                ObRecentOrdersCard(
                  orders: controller.recentOrders,
                  onOrderTap: controller.openOrder,
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
