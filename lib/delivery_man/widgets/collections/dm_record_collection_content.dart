import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_section_header.dart';
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: AppTextStyles.sectionTitle(context),
                        ),
                      ),
                      AppStatusChip.collectionMode(controller.mode),
                    ],
                  ),
                ),
                AppSpacing.vertical(context, 0.02),
                AppFormSectionHeader(
                  icon: AppIcons.invoices,
                  title: AppTexts.dmOpenInvoices,
                ),
                AppSpacing.vertical(context, 0.012),
                if (controller.isBatch) ...[
                  AppTextField(
                    controller: controller.batchAmountController,
                    label: AppTexts.dmCollectAmount,
                    hint: AppFormatter.currencyWhole(controller.remainingTotal),
                    required: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (_) => controller.onAmountChanged(),
                    suffixWidget: TextButton(
                      onPressed: controller.fillBatchRemaining,
                      child: Text(
                        AppTexts.dmFillRemaining,
                        style: AppTextStyles.caption(
                          context,
                        ).copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  AppSpacing.vertical(context, 0.008),
                  Text(
                    AppTexts.dmBatchAmountHint,
                    style: AppTextStyles.bodyText(
                      context,
                    ).copyWith(color: AppColors.grey),
                  ),
                  AppSpacing.vertical(context, 0.016),
                ],
                for (var i = 0; i < invoices.length; i++) ...[
                  if (i > 0) AppSpacing.vertical(context, 0.01),
                  DmCollectInvoiceRow(
                    invoice: invoices[i],
                    amountController: controller.isBatch
                        ? null
                        : controller.invoiceAmountControllers[invoices[i].id],
                    onAmountChanged: controller.onAmountChanged,
                    onFillRemaining: () =>
                        controller.fillInvoiceRemaining(invoices[i]),
                  ),
                ],
                AppSpacing.vertical(context, 0.024),
                AppFormSectionHeader(
                  icon: AppIcons.collections,
                  title: AppTexts.dmPaymentMethod,
                ),
                AppSpacing.vertical(context, 0.012),
                Obx(() {
                  final selected = controller.method.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final method in PaymentMethod.values)
                              AppFilterChip(
                                label: method.label,
                                color: method.chipColor,
                                selected: selected == method,
                                onTap: () => controller.selectMethod(method),
                              ),
                          ],
                        ),
                      ),
                      if (selected == PaymentMethod.cheque) ...[
                        AppSpacing.vertical(context, 0.016),
                        AppTextField(
                          controller: controller.referenceController,
                          label: AppTexts.dmChequeNumber,
                          hint: AppTexts.dmChequeNumberHint,
                          required: true,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                      if (selected == PaymentMethod.bank) ...[
                        AppSpacing.vertical(context, 0.016),
                        AppTextField(
                          controller: controller.referenceController,
                          label: AppTexts.dmBankReference,
                          hint: AppTexts.dmBankReferenceHint,
                          required: true,
                          textInputAction: TextInputAction.next,
                        ),
                        AppSpacing.vertical(context, 0.016),
                        SizedBox(
                          width: 160,
                          child: AppPhotoUploadTile(
                            title: AppTexts.dmBankScreenshotTitle,
                            subtitle: AppTexts.dmBankScreenshotSubtitle,
                            icon: AppIcons.cameraAdd,
                            imageBytes: controller.bankScreenshotBytes.value,
                            onTap: controller.pickBankScreenshot,
                          ),
                        ),
                      ],
                    ],
                  );
                }),
                AppSpacing.vertical(context, 0.02),
                AppTextField(
                  controller: controller.notesController,
                  label: AppTexts.dmCollectionNotes,
                  hint: AppTexts.dmCollectionNotesHint,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
                AppSpacing.vertical(context, 0.12),
              ],
            ),
          ),
          Obx(
            () => Material(
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
          ),
        ],
      );
    });
  }
}
