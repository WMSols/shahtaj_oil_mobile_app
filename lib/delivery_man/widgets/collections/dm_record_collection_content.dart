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
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_amount_summary_bar.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_photo_upload_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_record_collection_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_collect_invoice_row.dart';

class DmRecordCollectionContent extends GetView<DmRecordCollectionController> {
  const DmRecordCollectionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && !controller.hasCachedData) {
        return AppShimmerSkeletons.shopList(context);
      }

      if (controller.error.value != null && controller.shop.value == null) {
        return AppEmptyState(
          title: AppTexts.emptyLoadFailedTitle,
          subtitle: controller.error.value!,
          image: AppImages.emptyError,
          onRefresh: () => controller.loadForm(force: true),
        );
      }

      final shop = controller.shop.value;
      if (shop == null) {
        return AppEmptyState(
          title: AppTexts.emptyNotFoundTitle,
          subtitle: AppTexts.dmRecordCollectionTitle,
          image: AppImages.emptyNotFound,
          onRefresh: () => controller.loadForm(force: true),
        );
      }

      final invoices = controller.invoices;
      if (invoices.isEmpty) {
        return AppEmptyState(
          title: AppTexts.emptyNoInvoicesTitle,
          subtitle: AppTexts.dmNoOpenInvoicesSubtitle,
          image: AppImages.emptyNoInvoices,
        );
      }

      return Column(
        children: [
          Expanded(
            child: ListView(
              padding: AppSpacing.screenPadding(context),
              children: [
                AppOutlineCard(
                  padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
                  child: Text(
                    shop.shopName,
                    style: AppTextStyles.sectionTitle(context),
                  ),
                ),
                AppSpacing.vertical(context, 0.016),
                Text(
                  AppTexts.dmCollectionAllocations,
                  style: AppTextStyles.sectionTitle(context),
                ),
                AppSpacing.vertical(context, 0.01),
                for (final invoice in invoices) ...[
                  DmCollectInvoiceRow(
                    invoice: invoice,
                    amountController:
                        controller.invoiceAmountControllers[invoice.invoiceId],
                    onAmountChanged: controller.onAmountChanged,
                    onFillRemaining: () =>
                        controller.fillInvoiceRemaining(invoice),
                  ),
                  AppSpacing.vertical(context, 0.01),
                ],
                Text(
                  AppTexts.dmPaymentMethod,
                  style: AppTextStyles.sectionTitle(context),
                ),
                AppSpacing.vertical(context, 0.008),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final option
                        in DmRecordCollectionController.collectMethods)
                      ChoiceChip(
                        label: Text(option.label),
                        selected: controller.method.value == option,
                        onSelected: (_) => controller.setMethod(option),
                      ),
                  ],
                ),
                if (controller.method.value == PaymentMethod.cheque) ...[
                  AppSpacing.vertical(context, 0.012),
                  AppTextField(
                    controller: controller.chequeNumberController,
                    label: AppTexts.dmChequeNumber,
                    hint: AppTexts.dmChequeNumberHint,
                  ),
                  AppSpacing.vertical(context, 0.012),
                  SizedBox(
                    width: 160,
                    child: AppPhotoUploadTile(
                      title: AppTexts.dmChequeImageTitle,
                      subtitle: AppTexts.dmChequeImageSubtitle,
                      icon: AppIcons.cameraAdd,
                      imageBytes: controller.chequeImageBytes.value,
                      isUploading: controller.isSaving.value,
                      onTap: controller.pickChequeImage,
                    ),
                  ),
                ],
                AppSpacing.vertical(context, 0.012),
                AppTextField(
                  controller: controller.notesController,
                  label: AppTexts.dmCollectionNotes,
                  hint: AppTexts.dmCollectionNotesHint,
                  maxLines: 3,
                ),
                AppSpacing.vertical(context, 0.12),
              ],
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppAmountSummaryBar(
                      label: AppTexts.dmCollectAmount,
                      amount: controller.collectingTotal,
                    ),
                    AppSpacing.vertical(context, 0.008),
                    Text(
                      '${AppTexts.dmInvoiceRemaining}: '
                      '${AppFormatter.currencyWhole(controller.remainingTotal)}',
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(color: AppColors.grey),
                    ),
                    AppSpacing.vertical(context, 0.012),
                    AppPrimaryButton(
                      label: AppTexts.dmConfirmCollection,
                      isLoading: controller.isSaving.value,
                      onPressed: controller.submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
