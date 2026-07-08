import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/history/ob_visit_history_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_history_controller.dart';

class ObVisitHistoryContent extends GetView<ObHistoryController> {
  const ObVisitHistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppSpacing.screenPadding(context),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => AppSecondaryButton(
                    label: controller.dateFromLabel,
                    outlinedOnly: true,
                    onPressed: () => controller.pickDateFrom(context),
                  ),
                ),
              ),
              AppSpacing.horizontal(context, 0.02),
              Expanded(
                child: Obx(
                  () => AppSecondaryButton(
                    label: controller.dateToLabel,
                    outlinedOnly: true,
                    onPressed: () => controller.pickDateTo(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (!controller.hasDateFilter) return const SizedBox.shrink();
          return Padding(
            padding: AppSpacing.screenPadding(
              context,
            ).copyWith(top: 0, bottom: 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppSecondaryButton(
                label: AppTexts.obVisitClearDates,
                outlinedOnly: true,
                onPressed: controller.clearDateFilter,
              ),
            ),
          );
        }),
        AppSpacing.vertical(context, 0.01),
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenPadding(
              context,
            ).copyWith(top: 0, bottom: 0),
            child: Row(
              children: [
                for (final outcome in ObHistoryController.outcomeFilters)
                  AppFilterChip(
                    label: controller.outcomeFilterLabel(outcome),
                    selected: controller.isOutcomeSelected(outcome),
                    onTap: () => controller.selectOutcomeFilter(outcome),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const AppLoader();
            }

            if (controller.error.value != null) {
              return AppEmptyState(
                title: AppTexts.error,
                subtitle: controller.error.value!,
              );
            }

            final visits = controller.filteredVisits;
            if (visits.isEmpty) {
              return AppEmptyState(
                title: AppTexts.navHistory,
                subtitle: AppTexts.obNoVisitsFound,
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.loadVisits(reset: true),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 120) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: AppSpacing.screenPadding(context),
                  itemCount:
                      visits.length + (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= visits.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: AppLoader()),
                      );
                    }

                    final visit = visits[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: AppSpacing.verticalValue(context, 0.012),
                      ),
                      child: ObVisitHistoryCard(
                        visit: visit,
                        timeLabel: controller.visitTimeLabel(visit),
                        onTap: () => controller.openVisit(visit),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
