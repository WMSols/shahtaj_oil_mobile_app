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
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_section_header.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_collection_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_collection_invoice_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_collection_model.dart';

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

      final detailRows = collection.invoiceDetails.isNotEmpty
          ? collection.invoiceDetails
          : null;

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
            if (detailRows != null) ...[
              for (var i = 0; i < detailRows.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i < detailRows.length - 1
                        ? AppSpacing.verticalValue(context, 0.01)
                        : 0,
                  ),
                  child: _InvoiceDetailCard(invoice: detailRows[i]),
                ),
            ] else if (collection.invoices.isEmpty)
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
                    for (var i = 0; i < collection.invoices.length; i++)
                      AppDetailRow(
                        label: collection.invoices[i],
                        showDivider: i < collection.invoices.length - 1,
                      ),
                  ],
                ),
              ),
            if ((collection.notes ?? '').trim().isNotEmpty) ...[
              AppSpacing.vertical(context, 0.02),
              AppFormSectionHeader(
                icon: AppIcons.history,
                title: AppTexts.dmCollectionNotes,
              ),
              AppSpacing.vertical(context, 0.012),
              AppOutlineCard(
                padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
                child: Text(
                  collection.notes!,
                  style: AppTextStyles.bodyText(context),
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

  final DmWalletCollectionModel collection;

  @override
  Widget build(BuildContext context) {
    final collectedAt =
        '${AppFormatter.shortDate(collection.date)} • ${AppFormatter.timeOfDay(collection.date)}';
    final showCheque =
        collection.paymentMethod == PaymentMethod.cheque &&
        (collection.chequeNumber ?? '').trim().isNotEmpty;
    final status = collection.collectionStatus;
    final hasTotals = collection.hasInvoiceTotals;

    return AppOutlineCard(
      statusColor: status?.chipColor ?? collection.paymentMethod.chipColor,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AppDetailRow(label: AppTexts.dmReceiptNumber, value: collection.name),
          AppDetailRow(
            label: AppTexts.obShopNameLabel,
            value: collection.shopName,
            titleCaseValue: true,
          ),
          AppDetailRow(
            label: AppTexts.dmCollectAmount,
            value: AppFormatter.currencyWhole(collection.amount),
            valueColor: AppColors.primary,
            valueWeight: FontWeight.w700,
          ),
          if (hasTotals) ...[
            AppDetailRow(
              label: AppTexts.dmInvoiceTotal,
              value: AppFormatter.currencyWhole(collection.invoiceAmountTotal),
            ),
            AppDetailRow(
              label: AppTexts.dmInvoicePaid,
              value: AppFormatter.currencyWhole(collection.invoiceAmountPaid),
            ),
            if (collection.invoiceAmountResidual > 0)
              AppDetailRow(
                label: AppTexts.dmInvoiceRemaining,
                value: AppFormatter.currencyWhole(
                  collection.invoiceAmountResidual,
                ),
              ),
          ],
          AppDetailRow(
            label: AppTexts.dmPaymentMethod,
            trailing: AppStatusChip.paymentMethod(collection.paymentMethod),
          ),
          if (status != null)
            AppDetailRow(
              label: AppTexts.dmCollectionStatus,
              trailing: AppStatusChip.walletCollectionPay(status),
            ),
          if (collection.isWalkIn)
            AppDetailRow(
              label: AppTexts.dmWalkInTitle,
              trailing: AppStatusChip.walkIn(),
            ),
          AppDetailRow(
            label: AppTexts.dmCollectedAt,
            value: collectedAt,
            showDivider: showCheque,
          ),
          if (showCheque)
            AppDetailRow(
              label: AppTexts.dmChequeNumber,
              value: collection.chequeNumber!,
              showDivider: false,
            ),
        ],
      ),
    );
  }
}

class _InvoiceDetailCard extends StatelessWidget {
  const _InvoiceDetailCard({required this.invoice});

  final DmWalletCollectionInvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(
      context,
    ).copyWith(color: AppColors.grey);
    final state = invoice.resolvedPaymentState;

    return AppOutlineCard(
      statusColor: state?.chipColor ?? AppColors.primary,
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.014),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  invoice.name,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              if (state != null) AppStatusChip.invoicePayment(state),
            ],
          ),
          AppSpacing.vertical(context, 0.006),
          Text(
            '${AppTexts.dmInvoiceTotal}: '
            '${AppFormatter.currency(invoice.amountTotal, symbol: 'Rs. ')}'
            ' · ${AppTexts.dmInvoicePaid}: '
            '${AppFormatter.currency(invoice.amountPaid, symbol: 'Rs. ')}'
            ' · ${AppTexts.dmInvoiceRemaining}: '
            '${AppFormatter.currency(invoice.amountResidual, symbol: 'Rs. ')}',
            style: mutedStyle.copyWith(
              fontSize: AppResponsive.scaleSize(context, 12),
            ),
          ),
        ],
      ),
    );
  }
}
