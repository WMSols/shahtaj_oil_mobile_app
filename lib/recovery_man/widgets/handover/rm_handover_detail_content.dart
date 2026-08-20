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
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/handover/rm_handover_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/handover/rm_handover_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/history/rm_collection_history_card.dart';

class RmHandoverDetailContent extends GetView<RmHandoverDetailController> {
  const RmHandoverDetailContent({super.key});

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
          subtitle: AppTexts.rmHandoverNotFound,
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
                title: AppTexts.rmHandoverNotes,
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
            AppSectionHeader(title: AppTexts.rmHandoverCollections),
            AppSpacing.vertical(context, 0.01),
            if (controller.collections.isEmpty)
              Text(
                AppTexts.rmNoHandoversYet,
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.grey),
              )
            else
              for (var i = 0; i < controller.collections.length; i++) ...[
                if (i > 0) AppSpacing.vertical(context, 0.01),
                RmCollectionHistoryCard(
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

  final RmHandoverSummaryModel handover;
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
            label: AppTexts.rmHandoverReference,
            value: handover.reference,
          ),
          AppDetailRow(
            label: AppTexts.rmCollectionStatus,
            trailing: AppStatusChip.handover(handover.status),
          ),
          AppDetailRow(label: AppTexts.rmHandoverAt, value: handedAtLabel),
          AppDetailRow(
            label: AppTexts.rmBagCash,
            value: AppFormatter.currencyWhole(handover.cashAmount),
          ),
          AppDetailRow(
            label: AppTexts.rmBagCheque,
            value: AppFormatter.currencyWhole(handover.chequeAmount),
          ),
          AppDetailRow(
            label: AppTexts.rmBagTotal,
            value: AppFormatter.currencyWhole(handover.total),
            valueColor: AppColors.primary,
            valueWeight: FontWeight.w700,
          ),
          AppDetailRow(
            label: AppTexts.rmCashierName,
            value: handover.cashierName.isEmpty ? '—' : handover.cashierName,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
