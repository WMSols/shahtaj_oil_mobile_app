import 'dart:convert';

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
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_photo_upload_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_collection_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_summary_model.dart';

class RmCollectionDetailContent extends GetView<RmCollectionDetailController> {
  const RmCollectionDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && !controller.hasCachedData) {
        return AppShimmerSkeletons.genericList(context, count: 4);
      }

      if (controller.error.value != null &&
          controller.collection.value == null) {
        return AppEmptyState(
          title: AppTexts.emptyLoadFailedTitle,
          subtitle: controller.error.value!,
          image: AppImages.emptyError,
          onRefresh: () => controller.loadDetail(force: true),
        );
      }

      final collection = controller.collection.value;
      if (collection == null) {
        return AppEmptyState(
          title: AppTexts.emptyNotFoundTitle,
          subtitle: AppTexts.rmCollectionNotFound,
          image: AppImages.emptyNotFound,
          onRefresh: () => controller.loadDetail(force: true),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.loadDetail(force: true),
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            _HeaderCard(collection: collection),
            AppSpacing.vertical(context, 0.02),
            AppFormSectionHeader(
              icon: AppIcons.invoices,
              title: AppTexts.rmCollectionAllocations,
            ),
            AppSpacing.vertical(context, 0.012),
            if (collection.isUnallocatedBatch)
              AppOutlineCard(
                padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTexts.rmUnallocatedBatch,
                      style: AppTextStyles.sectionTitle(context),
                    ),
                    AppSpacing.vertical(context, 0.006),
                    Text(
                      AppTexts.rmUnallocatedBatchHint,
                      style: AppTextStyles.bodyText(
                        context,
                      ).copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              )
            else if (collection.lines.isEmpty)
              Text(
                AppTexts.rmUnallocatedBatchHint,
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.grey),
              )
            else
              AppOutlineCard(
                clipBehavior: Clip.antiAlias,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (var i = 0; i < collection.lines.length; i++)
                      AppDetailRow(
                        label: collection.lines[i].invoiceNumber,
                        value: AppFormatter.currencyWhole(
                          collection.lines[i].amount,
                        ),
                        showDivider: i < collection.lines.length - 1,
                      ),
                  ],
                ),
              ),
            if (collection.notes.trim().isNotEmpty) ...[
              AppSpacing.vertical(context, 0.02),
              AppFormSectionHeader(
                icon: AppIcons.history,
                title: AppTexts.rmCollectionNotes,
              ),
              AppSpacing.vertical(context, 0.012),
              AppOutlineCard(
                padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
                child: Text(
                  collection.notes,
                  style: AppTextStyles.bodyText(context),
                ),
              ),
            ],
            if (collection.proofPhotoBase64 != null &&
                collection.proofPhotoBase64!.isNotEmpty) ...[
              AppSpacing.vertical(context, 0.02),
              AppFormSectionHeader(
                icon: AppIcons.cameraAdd,
                title: AppTexts.rmBankScreenshotTitle,
              ),
              AppSpacing.vertical(context, 0.012),
              SizedBox(
                width: 160,
                child: AppPhotoUploadTile(
                  title: AppTexts.rmBankScreenshotTitle,
                  subtitle: AppTexts.rmBankScreenshotSubtitle,
                  icon: AppIcons.cameraAdd,
                  imageBytes: base64Decode(collection.proofPhotoBase64!),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.collection});

  final RmCollectionSummaryModel collection;

  String? get _referenceLabel {
    if (collection.reference.trim().isEmpty) return null;
    return switch (collection.method) {
      PaymentMethod.cheque => AppTexts.rmChequeNumber,
      PaymentMethod.bank => AppTexts.rmBankReference,
      PaymentMethod.cash => AppTexts.rmBankReference,
    };
  }

  @override
  Widget build(BuildContext context) {
    final collectedAt =
        '${AppFormatter.shortDate(collection.collectedAt)} • ${AppFormatter.timeOfDay(collection.collectedAt)}';
    final referenceLabel = _referenceLabel;

    return AppOutlineCard(
      statusColor: collection.status.chipColor,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AppDetailRow(
            label: AppTexts.rmReceiptNumber,
            value: collection.receiptNumber,
          ),
          AppDetailRow(
            label: AppTexts.obShopNameLabel,
            value: collection.shopName,
          ),
          AppDetailRow(
            label: AppTexts.rmCollectAmount,
            value: AppFormatter.currencyWhole(collection.amount),
            valueColor: AppColors.primary,
            valueWeight: FontWeight.w700,
          ),
          AppDetailRow(
            label: AppTexts.rmPaymentMethod,
            trailing: AppStatusChip.paymentMethod(collection.method),
          ),
          AppDetailRow(
            label: AppTexts.rmCollectionMode,
            trailing: AppStatusChip.collectionMode(collection.mode),
          ),
          AppDetailRow(
            label: AppTexts.rmCollectionStatus,
            trailing: AppStatusChip.collection(collection.status),
          ),
          AppDetailRow(
            label: AppTexts.rmCollectedAt,
            value: collectedAt,
            showDivider: referenceLabel != null,
          ),
          if (referenceLabel != null)
            AppDetailRow(
              label: referenceLabel,
              value: collection.reference,
              showDivider: false,
            ),
        ],
      ),
    );
  }
}
