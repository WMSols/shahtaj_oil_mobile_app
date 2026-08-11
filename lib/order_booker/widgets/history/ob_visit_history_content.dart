import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/history/ob_visit_history_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/history/ob_history_controller.dart';

class ObVisitHistoryContent extends GetView<ObHistoryController> {
  const ObVisitHistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppSpacing.screenPadding(context),
          child: AppSearchField(
            controller: controller.searchController,
            hint: AppTexts.obSearchVisitHint,
            prefixIcon: AppIcons.search,
            suffixIcon: null,
          ),
        ),
        Padding(
          padding: AppSpacing.screenPadding(context).copyWith(top: 0),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => _DateFilterTile(
                    label: AppTexts.obVisitFilterDateFrom,
                    value: controller.dateFrom.value == null
                        ? null
                        : controller.dateFromLabel,
                    onTap: () => controller.pickDateFrom(context),
                  ),
                ),
              ),
              AppSpacing.horizontal(context, 0.02),
              Expanded(
                child: Obx(
                  () => _DateFilterTile(
                    label: AppTexts.obVisitFilterDateTo,
                    value: controller.dateTo.value == null
                        ? null
                        : controller.dateToLabel,
                    onTap: () => controller.pickDateTo(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (!controller.hasDateFilter) return const SizedBox.shrink();
          return Padding(
            padding: AppSpacing.screenPadding(context).copyWith(
              top: 0,
              bottom: AppSpacing.verticalValue(context, 0.005),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _ClearDatesChip(onTap: controller.clearDateFilter),
            ),
          );
        }),
        AppSpacing.vertical(context, 0.005),
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
        Obx(() {
          final visits = controller.filteredVisits;
          if (controller.isLoading.value || visits.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: AppSpacing.screenPadding(
              context,
            ).copyWith(top: AppSpacing.verticalValue(context, 0.01), bottom: 0),
            child: Text(
              AppTexts.obHistoryTotals(
                visits.length,
                AppFormatter.currencyWhole(controller.filteredOrdersTotal),
              ),
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          );
        }),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return AppShimmerSkeletons.genericList(context);
            }

            if (controller.error.value != null) {
              return AppEmptyState(
                title: AppTexts.emptyLoadFailedTitle,
                subtitle: controller.error.value!,
                image: AppImages.emptyError,
                onRefresh: () => controller.loadVisits(reset: true),
              );
            }

            final visits = controller.filteredVisits;
            if (visits.isEmpty) {
              return AppEmptyState(
                title: AppTexts.emptyNoVisitsTitle,
                subtitle: controller.searchQuery.value.trim().isEmpty
                    ? AppTexts.obNoVisitsFound
                    : AppTexts.obNoVisitsMatchSearch,
                image: AppImages.emptyNoVisits,
                onRefresh: () => controller.loadVisits(reset: true),
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
                        durationLabel: controller.visitDurationLabel(visit),
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

class _DateFilterTile extends StatelessWidget {
  const _DateFilterTile({required this.label, required this.onTap, this.value});

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.trim().isNotEmpty;
    final radius = AppResponsive.radius(context);

    return Material(
      color: hasValue ? AppColors.primary : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: hasValue ? AppColors.primary : AppColors.cardBorder,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.03, v: 0.012),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppResponsive.scaleSize(context, 7)),
                decoration: BoxDecoration(
                  color: hasValue
                      ? AppColors.white.withValues(alpha: 0.18)
                      : AppColors.inputFill,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Icon(
                  AppIcons.calendar,
                  color: hasValue ? AppColors.white : AppColors.primary,
                  size: AppResponsive.iconSize(context, factor: 0.85),
                ),
              ),
              AppSpacing.horizontal(context, 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.caption(context).copyWith(
                        color: hasValue
                            ? AppColors.white.withValues(alpha: 0.9)
                            : AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      hasValue ? value! : AppTexts.selectDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyText(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: hasValue ? AppColors.white : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClearDatesChip extends StatelessWidget {
  const _ClearDatesChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.error.withValues(alpha: 0.08),
      shape: StadiumBorder(
        side: BorderSide(color: AppColors.error.withValues(alpha: 0.35)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalValue(context, 0.035),
            vertical: AppSpacing.verticalValue(context, 0.007),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                AppIcons.close,
                size: AppResponsive.scaleSize(context, 14),
                color: AppColors.error,
              ),
              AppSpacing.horizontal(context, 0.012),
              Text(
                AppTexts.obVisitClearDates.toUpperCase(),
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: AppColors.error, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
