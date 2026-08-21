import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_async_body.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_collection_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_collection_history_card.dart';

class DmCollectionHistoryContent
    extends GetView<DmCollectionHistoryController> {
  const DmCollectionHistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppSpacing.screenPadding(context),
          child: AppSearchField(
            key: const ValueKey('dm_collection_history_search'),
            hint: AppTexts.dmSearchCollectionHint,
            prefixIcon: AppIcons.search,
            suffixIcon: null,
            onChanged: controller.onSearchChanged,
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
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenPadding(
              context,
            ).copyWith(top: 0, bottom: 0),
            child: Row(
              children: [
                for (final method
                    in DmCollectionHistoryController.methodFilters)
                  AppFilterChip(
                    label: controller.methodFilterLabel(method),
                    selected: controller.isMethodSelected(method),
                    color: method?.chipColor ?? AppColors.primary,
                    onTap: () => controller.selectMethodFilter(method),
                  ),
              ],
            ),
          ),
        ),
        Obx(() {
          final rows = controller.filteredCollections;
          if (controller.isLoading.value || rows.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: AppSpacing.screenPadding(
              context,
            ).copyWith(top: AppSpacing.verticalValue(context, 0.01), bottom: 0),
            child: Text(
              AppTexts.dmHistoryTotals(
                rows.length,
                AppFormatter.currencyWhole(controller.filteredTotal),
              ),
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          );
        }),
        Expanded(
          child: Obx(() {
            final rows = controller.filteredCollections;
            final hasQuery = controller.searchQuery.value.trim().isNotEmpty;
            final isFiltered = controller.methodFilter.value != null;

            return AppAsyncBody(
              isLoading:
                  controller.isLoading.value && !controller.hasCachedData,
              hasError: controller.error.value != null && rows.isEmpty,
              isEmpty: rows.isEmpty,
              errorMessage: controller.error.value,
              emptyTitle: AppTexts.emptyNoCollectionsTitle,
              emptySubtitle: hasQuery || isFiltered || controller.hasDateFilter
                  ? AppTexts.dmNoCollectionsMatchSearch
                  : AppTexts.dmNoRecentCollections,
              emptyImage: AppImages.emptyNoCollections,
              onRefresh: () => controller.loadHistory(force: true),
              loading: AppShimmerSkeletons.genericList(context),
              child: ListView.builder(
                padding: AppSpacing.screenPadding(context),
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  final collection = rows[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppSpacing.verticalValue(context, 0.01),
                    ),
                    child: DmCollectionHistoryCard(
                      collection: collection,
                      timeLabel: controller.timeLabel(collection),
                      onTap: () => controller.openCollection(collection),
                    ),
                  );
                },
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
