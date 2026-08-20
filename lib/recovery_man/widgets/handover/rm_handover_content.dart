import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/handover/rm_handover_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/handover/rm_bag_snapshot_strip.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/handover/rm_handover_summary_card.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/history/rm_collection_history_card.dart';

class RmHandoverContent extends GetView<RmHandoverController> {
  const RmHandoverContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && !controller.hasCachedData) {
        return AppShimmerSkeletons.genericList(context);
      }

      if (controller.error.value != null && !controller.hasCachedData) {
        return AppEmptyState(
          title: AppTexts.emptyLoadFailedTitle,
          subtitle: controller.error.value!,
          image: AppImages.emptyError,
          onRefresh: () => controller.loadHandover(force: true),
        );
      }

      return Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.loadHandover(force: true),
              child: ListView(
                padding: AppSpacing.screenPadding(context),
                children: [
                  RmBagSnapshotStrip(
                    cashInBag: controller.cashInBag.value,
                    chequeInBag: controller.chequeInBag.value,
                    bagTotal: controller.bagTotal.value,
                  ),
                  AppSpacing.vertical(context, 0.02),
                  AppSectionHeader(title: AppTexts.rmPendingHandover),
                  AppSpacing.vertical(context, 0.01),
                  if (controller.bagCollections.isEmpty)
                    AppEmptyState(
                      title: AppTexts.emptyNoHandoverTitle,
                      subtitle: AppTexts.rmNoBagCollectionsSubtitle,
                      image: AppImages.emptyNoHandover,
                    )
                  else
                    for (
                      var i = 0;
                      i < controller.bagCollections.length;
                      i++
                    ) ...[
                      if (i > 0) AppSpacing.vertical(context, 0.01),
                      RmCollectionHistoryCard(
                        collection: controller.bagCollections[i],
                        timeLabel: controller.collectionTimeLabel(
                          controller.bagCollections[i],
                        ),
                        onTap: () => controller.openCollection(
                          controller.bagCollections[i],
                        ),
                      ),
                    ],
                  AppSpacing.vertical(context, 0.024),
                  AppSectionHeader(title: AppTexts.rmRecentHandovers),
                  AppSpacing.vertical(context, 0.01),
                  if (controller.recentHandovers.isEmpty)
                    Text(
                      AppTexts.rmNoHandoversYet,
                      style: AppTextStyles.bodyText(
                        context,
                      ).copyWith(color: AppColors.grey),
                    )
                  else
                    for (
                      var i = 0;
                      i < controller.recentHandovers.length;
                      i++
                    ) ...[
                      if (i > 0) AppSpacing.vertical(context, 0.01),
                      RmHandoverSummaryCard(
                        handover: controller.recentHandovers[i],
                        timeLabel: controller.handoverTimeLabel(
                          controller.recentHandovers[i],
                        ),
                        onTap: () => controller.openHandover(
                          controller.recentHandovers[i],
                        ),
                      ),
                    ],
                  AppSpacing.vertical(context, 0.12),
                ],
              ),
            ),
          ),
          Material(
            color: AppColors.white,
            elevation: 8,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: AppSpacing.screenPadding(context).copyWith(
                  top: AppSpacing.verticalValue(context, 0.012),
                  bottom: AppSpacing.verticalValue(context, 0.012),
                ),
                child: AppPrimaryButton(
                  label: AppTexts.rmHandOverBag,
                  onPressed: controller.canHandOver
                      ? controller.openConfirm
                      : null,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
