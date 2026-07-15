import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/dashboard/ob_route_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/tasks/ob_active_visit_banner.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/tasks/ob_task_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/tasks/ob_today_tasks_progress.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_route_detail_controller.dart';

class ObTodayTasksContent extends GetView<ObRouteDetailController> {
  const ObTodayTasksContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const AppLoader();
      }

      if (controller.error.value != null) {
        return AppEmptyState(
          title: AppTexts.emptyLoadFailedTitle,
          subtitle: controller.error.value!,
          image: AppImages.emptyError,
          onRefresh: () => controller.loadTasks(force: true),
        );
      }

      final data = controller.todayTasks.value;
      if (data == null) {
        return AppEmptyState(
          title: AppTexts.emptyNoTasksTitle,
          subtitle: AppTexts.obNoTasksToday,
          image: AppImages.emptyNoTasks,
          onRefresh: () => controller.loadTasks(force: true),
        );
      }

      final tasks = data.tasks;
      final activeVisit = controller.activeVisit.value;

      return RefreshIndicator(
        onRefresh: () => controller.loadTasks(force: true),
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            ObRouteCard(route: data.route, showAction: false),
            AppSpacing.vertical(context, 0.016),
            ObTodayTasksProgress(
              completed: data.completedCount,
              total: data.totalCount,
            ),
            if (activeVisit != null) ...[
              AppSpacing.vertical(context, 0.016),
              ObActiveVisitBanner(
                visit: activeVisit,
                onResume: controller.resumeActiveVisit,
              ),
            ],
            AppSpacing.vertical(context, 0.02),
            Text(
              AppTexts.obTasksSection,
              style: AppTextStyles.sectionTitle(context),
            ),
            AppSpacing.vertical(context, 0.012),
            if (tasks.isEmpty)
              AppEmptyState(
                title: AppTexts.emptyNoTasksTitle,
                subtitle: AppTexts.obNoTasksToday,
                image: AppImages.emptyNoTasks,
              )
            else
              ...tasks.map((task) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: AppSpacing.verticalValue(context, 0.012),
                  ),
                  child: ObTaskCard(
                    task: task,
                    onCheckIn: task.status == TaskStatus.pending
                        ? () => controller.openCheckIn(task)
                        : null,
                    onSkip: task.status == TaskStatus.pending
                        ? () => controller.confirmSkipTask(task)
                        : null,
                    onNotes: () => controller.openTaskNotes(task),
                    onTap: task.status == TaskStatus.inVisit
                        ? controller.resumeActiveVisit
                        : null,
                  ),
                );
              }),
          ],
        ),
      );
    });
  }
}
