import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_dashboard_section_header.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_route_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/schedule/ob_weekday_plan_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_weekly_schedule_controller.dart';

class ObWeeklyScheduleContent extends GetView<ObWeeklyScheduleController> {
  const ObWeeklyScheduleContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) return const AppLoader();
      if (controller.error.value != null) {
        return AppEmptyState(
          title: AppTexts.navWeeklySchedule,
          subtitle: controller.error.value!,
        );
      }

      final todaysRoute = controller.todaysRoute.value;
      final days = controller.days;

      return RefreshIndicator(
        onRefresh: controller.load,
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            ObDashboardSectionHeader(title: AppTexts.obTodaysRoute),
            AppSpacing.vertical(context, 0.01),
            if (todaysRoute == null)
              AppEmptyState(
                title: AppTexts.obTodaysRoute,
                subtitle: AppTexts.obNoRouteAssigned,
              )
            else
              ObRouteCard(
                route: todaysRoute,
                onActionTap: controller.onTodayRouteAction,
              ),
            AppSpacing.vertical(context, 0.02),
            ObDashboardSectionHeader(title: AppTexts.obWeeklyScheduleTitle),
            AppSpacing.vertical(context, 0.01),
            if (days.isEmpty)
              AppEmptyState(
                title: AppTexts.obWeeklyScheduleTitle,
                subtitle: AppTexts.noDataYet,
              )
            else
              ...days.map(
                (day) => Padding(
                  padding: EdgeInsets.only(
                    bottom: AppSpacing.verticalValue(context, 0.01),
                  ),
                  child: ObWeekdayPlanCard(day: day),
                ),
              ),
          ],
        ),
      );
    });
  }
}
