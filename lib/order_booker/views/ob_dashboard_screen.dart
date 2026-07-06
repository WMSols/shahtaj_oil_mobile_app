import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_dashboard_greeting.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_dashboard_section_header.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_orders_target_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_recent_orders_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_route_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_dashboard_controller.dart';

class ObDashboardScreen extends GetView<ObDashboardController> {
  const ObDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoader();
        }

        if (controller.error.value != null) {
          return AppEmptyState(
            title: AppTexts.error,
            subtitle: controller.error.value!,
          );
        }

        final route = controller.todaysRoute;

        return RefreshIndicator(
          onRefresh: controller.loadDashboard,
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            children: [
              ObDashboardGreeting(
                greeting: controller.greeting,
                userName: controller.userName,
              ),
              AppSpacing.vertical(context, 0.02),
              ObDashboardSectionHeader(title: AppTexts.obTodaysRoute),
              if (route == null)
                AppEmptyState(
                  title: AppTexts.obTodaysRoute,
                  subtitle: AppTexts.obNoRouteAssigned,
                )
              else
                ObRouteCard(
                  route: route,
                  onActionTap: controller.onRouteAction,
                ),
              AppSpacing.vertical(context, 0.01),
              ObDashboardSectionHeader(title: AppTexts.obTargets),
              ObOrdersTargetCard(targets: controller.targets),
              AppSpacing.vertical(context, 0.01),
              ObDashboardSectionHeader(
                title: AppTexts.obRecentOrders,
                onViewAll: controller.goToOrderHistory,
              ),
              if (controller.recentOrders.isEmpty)
                AppEmptyState(
                  title: AppTexts.obRecentOrders,
                  subtitle: AppTexts.obNoRecentOrders,
                )
              else
                ObRecentOrdersCard(
                  orders: controller.recentOrders,
                  onOrderTap: controller.openOrder,
                ),
            ],
          ),
        );
      }),
    );
  }
}
