import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/reports/reports_list_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/widgets/reports/report_card.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_fab_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';

class ReportsListScreen extends GetView<ReportsListController> {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.reportsTitle,
      floatingActionButton: AppFABButton(
        label: AppTexts.reportCreateTitle,
        icon: AppIcons.add,
        onPressed: controller.openCreate,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: AppSpacing.screenPadding(context).copyWith(bottom: 0),
            child: AppSearchField(
              controller: controller.searchController,
              hint: AppTexts.reportSearchHint,
              prefixIcon: AppIcons.search,
              suffixIcon: null,
            ),
          ),
          AppSpacing.vertical(context, 0.01),
          SizedBox(
            height: AppSpacing.verticalValue(context, 0.055),
            child: Obx(
              () => ListView(
                scrollDirection: Axis.horizontal,
                padding: AppSpacing.screenPadding(context).copyWith(top: 0),
                children: [
                  AppFilterChip(
                    label: AppTexts.reportStateAll,
                    selected: controller.stateFilter.value == null,
                    uppercase: false,
                    onTap: () => controller.selectState(null),
                  ),
                  for (final state in ReportState.values)
                    Padding(
                      padding: EdgeInsets.only(
                        left: AppSpacing.horizontalValue(context, 0.015),
                      ),
                      child: AppFilterChip(
                        label: state.label,
                        color: state.chipColor,
                        selected: controller.stateFilter.value == state,
                        uppercase: false,
                        onTap: () => controller.selectState(state),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: Obx(() => _buildListBody(context))),
        ],
      ),
    );
  }

  Widget _buildListBody(BuildContext context) {
    if (controller.isLoading.value && controller.reports.isEmpty) {
      return AppShimmerSkeletons.genericList(context, count: 6);
    }

    if (controller.error.value != null && controller.reports.isEmpty) {
      return AppEmptyState(
        title: AppTexts.emptyLoadFailedTitle,
        subtitle: controller.error.value,
        image: AppImages.emptyError,
        onRefresh: () => controller.load(reset: true, force: true),
      );
    }

    final items = controller.filteredReports;
    if (items.isEmpty) {
      return AppEmptyState(
        title: controller.searchQuery.value.trim().isEmpty
            ? AppTexts.emptyNoReportsTitle
            : AppTexts.emptyNoReportsTitle,
        subtitle: controller.searchQuery.value.trim().isEmpty
            ? AppTexts.emptyNoReportsSubtitle
            : AppTexts.reportNoSearchMatches,
        image: AppImages.empty,
        onRefresh: () => controller.load(reset: true, force: true),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => controller.load(reset: true, force: true),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 120) {
                controller.load();
              }
              return false;
            },
            child: ListView.separated(
              padding: AppSpacing.screenPadding(context),
              itemCount:
                  items.length + (controller.isLoadingMore.value ? 1 : 0),
              separatorBuilder: (_, _) => AppSpacing.vertical(context, 0.01),
              itemBuilder: (context, index) {
                if (index >= items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final report = items[index];
                return ReportCard(
                  report: report,
                  onTap: () => controller.openDetail(report),
                );
              },
            ),
          ),
        ),
        if (controller.isRefreshing.value)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}
