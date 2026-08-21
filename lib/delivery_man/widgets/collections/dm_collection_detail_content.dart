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
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_collection_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_collection_summary_model.dart';

class DmCollectionDetailContent extends GetView<DmCollectionDetailController> {
  const DmCollectionDetailContent({super.key});

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
          subtitle: AppTexts.dmCollectionNotFound,
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
              title: AppTexts.dmCollectionAllocations,
            ),
            AppSpacing.vertical(context, 0.012),
            if (collection.isUnallocatedBatch)
              AppOutlineCard(
                padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTexts.dmUnallocatedBatch,
                      style: AppTextStyles.sectionTitle(context),
                    ),
                    AppSpacing.vertical(context, 0.006),
                    Text(
                      AppTexts.dmUnallocatedBatchHint,
                      style: AppTextStyles.bodyText(
                        context,
                      ).copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              )
            else if (collection.lines.isEmpty)
              Text(
                AppTexts.dmUnallocatedBatchHint,
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
                title: AppTexts.dmCollectionNotes,
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
                title: AppTexts.dmBankScreenshotTitle,
              ),
              AppSpacing.vertical(context, 0.012),
              SizedBox(
                width: 160,
                child: AppPhotoUploadTile(
                  title: AppTexts.dmBankScreenshotTitle,
                  subtitle: AppTexts.dmBankScreenshotSubtitle,
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

  final DmCollectionSummaryModel collection;

  String? get _referenceLabel {
    if (collection.reference.trim().isEmpty) return null;
    return switch (collection.method) {
      PaymentMethod.cheque => AppTexts.dmChequeNumber,
      PaymentMethod.bank => AppTexts.dmBankReference,
      PaymentMethod.cash => AppTexts.dmBankReference,
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
            label: AppTexts.dmReceiptNumber,
            value: collection.receiptNumber,
          ),
          AppDetailRow(
            label: AppTexts.obShopNameLabel,
            value: collection.shopName,
          ),
          AppDetailRow(
            label: AppTexts.dmCollectAmount,
            value: AppFormatter.currencyWhole(collection.amount),
            valueColor: AppColors.primary,
            valueWeight: FontWeight.w700,
          ),
          AppDetailRow(
            label: AppTexts.dmPaymentMethod,
            trailing: AppStatusChip.paymentMethod(collection.method),
          ),
          AppDetailRow(
            label: AppTexts.dmCollectionMode,
            trailing: AppStatusChip.collectionMode(collection.mode),
          ),
          AppDetailRow(
            label: AppTexts.dmCollectionStatus,
            trailing: AppStatusChip.collection(collection.status),
          ),
          AppDetailRow(
            label: AppTexts.dmCollectedAt,
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
