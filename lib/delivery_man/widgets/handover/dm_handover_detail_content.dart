import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_section_header.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/handover/dm_handover_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/handover/dm_handover_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_collection_history_card.dart';

class DmHandoverDetailContent extends GetView<DmHandoverDetailController> {
  const DmHandoverDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && !controller.hasCachedData) {
        return AppShimmerSkeletons.genericList(context, count: 4);
      }

      if (controller.error.value != null && controller.handover.value == null) {
        return AppEmptyState(
          title: AppTexts.emptyLoadFailedTitle,
          subtitle: controller.error.value!,
          image: AppImages.emptyError,
          onRefresh: () => controller.loadDetail(force: true),
        );
      }

      final handover = controller.handover.value;
      if (handover == null) {
        return AppEmptyState(
          title: AppTexts.emptyNotFoundTitle,
          subtitle: AppTexts.dmHandoverNotFound,
          image: AppImages.emptyNotFound,
          onRefresh: () => controller.loadDetail(force: true),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.loadDetail(force: true),
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            _HandoverHeader(
              handover: handover,
              handedAtLabel: controller.handedAtLabel(handover),
            ),
            if (handover.notes.trim().isNotEmpty) ...[
              AppSpacing.vertical(context, 0.02),
              AppFormSectionHeader(
                icon: AppIcons.history,
                title: AppTexts.dmHandoverNotes,
              ),
              AppSpacing.vertical(context, 0.012),
              AppOutlineCard(
                padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
                child: Text(
                  handover.notes,
                  style: AppTextStyles.bodyText(context),
                ),
              ),
            ],
            AppSpacing.vertical(context, 0.02),
            AppSectionHeader(title: AppTexts.dmHandoverCollections),
            AppSpacing.vertical(context, 0.01),
            if (controller.collections.isEmpty)
              Text(
                AppTexts.dmNoHandoversYet,
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.grey),
              )
            else
              for (var i = 0; i < controller.collections.length; i++) ...[
                if (i > 0) AppSpacing.vertical(context, 0.01),
                DmCollectionHistoryCard(
                  collection: controller.collections[i],
                  timeLabel: controller.collectionTimeLabel(
                    controller.collections[i],
                  ),
                  onTap: () =>
                      controller.openCollection(controller.collections[i]),
                ),
              ],
          ],
        ),
      );
    });
  }
}

class _HandoverHeader extends StatelessWidget {
  const _HandoverHeader({required this.handover, required this.handedAtLabel});

  final DmHandoverSummaryModel handover;
  final String handedAtLabel;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      statusColor: handover.status.chipColor,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AppDetailRow(
            label: AppTexts.dmHandoverReference,
            value: handover.reference,
          ),
          AppDetailRow(
            label: AppTexts.dmCollectionStatus,
            trailing: AppStatusChip.handover(handover.status),
          ),
          AppDetailRow(label: AppTexts.dmHandoverAt, value: handedAtLabel),
          AppDetailRow(
            label: AppTexts.dmBagCash,
            value: AppFormatter.currencyWhole(handover.cashAmount),
          ),
          AppDetailRow(
            label: AppTexts.dmBagCheque,
            value: AppFormatter.currencyWhole(handover.chequeAmount),
          ),
          AppDetailRow(
            label: AppTexts.dmBagTotal,
            value: AppFormatter.currencyWhole(handover.total),
            valueColor: AppColors.primary,
            valueWeight: FontWeight.w700,
          ),
          AppDetailRow(
            label: AppTexts.dmCashierName,
            value: handover.cashierName.isEmpty ? '—' : handover.cashierName,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
