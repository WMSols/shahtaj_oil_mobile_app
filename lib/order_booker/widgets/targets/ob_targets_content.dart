import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/targets/ob_target_progress_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_async_body.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/targets/ob_targets_controller.dart';

class ObTargetsContent extends GetView<ObTargetsController> {
  const ObTargetsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.filteredSortedTargets;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenPadding(context).copyWith(bottom: 0),
            child: Row(
              children: [
                for (final type in ObTargetsController.typeFilters)
                  AppFilterChip(
                    label: controller.typeFilterLabel(type),
                    selected: controller.isTypeSelected(type),
                    onTap: () => controller.selectTypeFilter(type),
                  ),
              ],
            ),
          ),
          AppSpacing.vertical(context, 0.008),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenPadding(context).copyWith(top: 0),
            child: Row(
              children: [
                for (final mode in ObTargetSortMode.values)
                  AppFilterChip(
                    label: controller.sortModeLabel(mode),
                    selected: controller.sortMode.value == mode,
                    onTap: () => controller.selectSortMode(mode),
                  ),
              ],
            ),
          ),
          Expanded(
            child: AppAsyncBody(
              isLoading: controller.isLoading.value,
              hasError: controller.error.value != null,
              isEmpty: items.isEmpty,
              errorMessage: controller.error.value,
              emptyTitle: AppTexts.emptyNoTargetsTitle,
              emptySubtitle: AppTexts.noDataYet,
              emptyImage: AppImages.emptyNoTargets,
              onRefresh: () => controller.load(force: true),
              loading: AppShimmerSkeletons.genericList(context, count: 4),
              child: ListView(
                padding: AppSpacing.screenPadding(context),
                children: items
                    .map(
                      (item) => Padding(
                        padding: EdgeInsets.only(
                          bottom: AppSpacing.verticalValue(context, 0.01),
                        ),
                        child: ObTargetProgressCard(
                          controller: controller,
                          target: item,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      );
    });
  }
}
