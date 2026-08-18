import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/dashboard/ob_route_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/tasks/ob_active_visit_banner.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/tasks/ob_task_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/tasks/ob_today_tasks_progress.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/tasks/ob_route_detail_controller.dart';

class ObTodayTasksContent extends GetView<ObRouteDetailController> {
  const ObTodayTasksContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.todayTasks.value == null) {
        return AppShimmerSkeletons.taskList(context);
      }

      if (controller.error.value != null &&
          controller.todayTasks.value == null) {
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
            Obx(() {
              final activeVisit = controller.activeVisit.value;
              if (activeVisit == null) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.verticalValue(context, 0.016),
                ),
                child: ObActiveVisitBanner(
                  visit: activeVisit,
                  onResume: controller.resumeActiveVisit,
                ),
              );
            }),
            AppSpacing.vertical(context, 0.016),
            AppSearchField(
              key: const ValueKey('ob_today_tasks_search'),
              hint: AppTexts.obSearchTaskHint,
              prefixIcon: AppIcons.search,
              suffixIcon: null,
              onChanged: controller.onSearchChanged,
            ),
            AppSpacing.vertical(context, 0.012),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AppFilterChip(
                      label: AppTexts.obShopsFilterAll,
                      selected: controller.isFilterSelected(null),
                      onTap: () => controller.selectStatusFilter(null),
                    ),
                    for (final status in ObRouteDetailController.filterStatuses)
                      AppFilterChip.taskStatus(
                        status: status,
                        selected: controller.isFilterSelected(status),
                        onTap: () => controller.selectStatusFilter(status),
                      ),
                  ],
                ),
              ),
            ),
            AppSpacing.vertical(context, 0.016),
            Text(
              AppTexts.obTasksSection,
              style: AppTextStyles.sectionTitle(context),
            ),
            AppSpacing.vertical(context, 0.012),
            Obx(() {
              final tasks = controller.filteredSortedTasks;
              if (tasks.isEmpty) {
                return AppEmptyState(
                  title: AppTexts.emptyNoTasksTitle,
                  subtitle: controller.searchQuery.value.trim().isEmpty
                      ? AppTexts.obNoTasksToday
                      : AppTexts.obNoTasksMatchSearch,
                  image: AppImages.emptyNoTasks,
                );
              }
              return Column(
                children: [
                  for (final task in tasks)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: AppSpacing.verticalValue(context, 0.012),
                      ),
                      child: ObTaskCard(
                        task: task,
                        isCheckingIn:
                            controller.checkingInTaskId.value == task.id,
                        onCheckIn: task.status == TaskStatus.pending
                            ? () => controller.openCheckIn(task)
                            : null,
                        onNotes: () => controller.openTaskNotes(task),
                        onTap: task.status == TaskStatus.inVisit
                            ? controller.resumeActiveVisit
                            : null,
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      );
    });
  }
}
