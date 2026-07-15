import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_dashboard_greeting.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_orders_target_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_recent_orders_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_route_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
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
            title: AppTexts.emptyLoadFailedTitle,
            subtitle: controller.error.value!,
            image: AppImages.emptyError,
            onRefresh: () => controller.loadDashboard(force: true),
          );
        }

        final route = controller.todaysRoute;

        return RefreshIndicator(
          onRefresh: () => controller.loadDashboard(force: true),
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            children: [
              ObDashboardGreeting(
                greeting: controller.greeting,
                userName: controller.userName,
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
                  onActionTap: controller.onRouteAction,
                ),
              AppSpacing.vertical(context, 0.01),
              AppSectionHeader(
                title: AppTexts.obTargets,
                onViewAll: controller.goToTargets,
              ),
              ObOrdersTargetCard(targets: controller.targets),
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
      }),
    );
  }
}
