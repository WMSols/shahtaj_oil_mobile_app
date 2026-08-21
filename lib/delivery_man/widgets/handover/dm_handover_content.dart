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
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/handover/dm_handover_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/handover/dm_bag_snapshot_strip.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/handover/dm_handover_summary_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_collection_history_card.dart';

class DmHandoverContent extends GetView<DmHandoverController> {
  const DmHandoverContent({super.key});

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
                  DmBagSnapshotStrip(
                    cashInBag: controller.cashInBag.value,
                    chequeInBag: controller.chequeInBag.value,
                    bagTotal: controller.bagTotal.value,
                  ),
                  AppSpacing.vertical(context, 0.02),
                  AppSectionHeader(title: AppTexts.dmPendingHandover),
                  AppSpacing.vertical(context, 0.01),
                  if (controller.bagCollections.isEmpty)
                    AppEmptyState(
                      title: AppTexts.emptyNoHandoverTitle,
                      subtitle: AppTexts.dmNoBagCollectionsSubtitle,
                      image: AppImages.emptyNoHandover,
                    )
                  else
                    for (
                      var i = 0;
                      i < controller.bagCollections.length;
                      i++
                    ) ...[
                      if (i > 0) AppSpacing.vertical(context, 0.01),
                      DmCollectionHistoryCard(
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
                  AppSectionHeader(title: AppTexts.dmRecentHandovers),
                  AppSpacing.vertical(context, 0.01),
                  if (controller.recentHandovers.isEmpty)
                    Text(
                      AppTexts.dmNoHandoversYet,
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
                      DmHandoverSummaryCard(
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
                  label: AppTexts.dmHandOverBag,
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
