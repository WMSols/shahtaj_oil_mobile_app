import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_amount_summary_bar.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_shop_invoices_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_invoice_tile.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_paid_invoice_tile.dart';

class DmShopOutstandingContent extends GetView<DmShopInvoicesController> {
  const DmShopOutstandingContent({super.key});

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
          onRefresh: () => controller.loadOutstanding(force: true),
        );
      }

      final shop = controller.shop.value;
      if (shop == null) {
        return AppEmptyState(
          title: AppTexts.emptyNotFoundTitle,
          subtitle: AppTexts.dmShopOutstandingTitle,
          image: AppImages.emptyNotFound,
          onRefresh: () => controller.loadOutstanding(force: true),
        );
      }

      final invoices = controller.invoices;
      final paidInvoices = controller.paidInvoices;
      final selectedCount = controller.selectedInvoiceIds.length;

      return Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.loadOutstanding(force: true),
              child: ListView(
                padding: AppSpacing.screenPadding(context),
                children: [
                  _ShopCreditSection(shop: shop),
                  AppSpacing.vertical(context, 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppTexts.dmOpenInvoices,
                          style: AppTextStyles.sectionTitle(context),
                        ),
                      ),
                      if (invoices.isNotEmpty)
                        TextButton(
                          onPressed: selectedCount == invoices.length
                              ? controller.clearSelection
                              : controller.selectAll,
                          child: Text(
                            selectedCount == invoices.length
                                ? AppTexts.dmDeselectAll
                                : AppTexts.dmSelectAll,
                            style: AppTextStyles.bodyText(
                              context,
                            ).copyWith(color: AppColors.primary),
                          ),
                        ),
                    ],
                  ),
                  AppSpacing.vertical(context, 0.008),
                  if (invoices.isEmpty)
                    AppEmptyState(
                      title: AppTexts.emptyNoInvoicesTitle,
                      subtitle: AppTexts.dmNoOpenInvoicesSubtitle,
                      image: AppImages.emptyNoInvoices,
                    )
                  else
                    for (var i = 0; i < invoices.length; i++) ...[
                      if (i > 0) AppSpacing.vertical(context, 0.01),
                      DmInvoiceTile(
                        invoice: invoices[i],
                        selected: controller.isSelected(invoices[i].invoiceId),
                        onTap: () =>
                            controller.toggleInvoice(invoices[i].invoiceId),
                      ),
                    ],
                  AppSpacing.vertical(context, 0.024),
                  Text(
                    AppTexts.dmPaidInvoices,
                    style: AppTextStyles.sectionTitle(context),
                  ),
                  AppSpacing.vertical(context, 0.008),
                  if (paidInvoices.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.verticalValue(context, 0.012),
                      ),
                      child: Text(
                        AppTexts.dmNoPaidInvoicesSubtitle,
                        style: AppTextStyles.bodyText(
                          context,
                        ).copyWith(color: AppColors.grey),
                      ),
                    )
                  else
                    for (var i = 0; i < paidInvoices.length; i++) ...[
                      if (i > 0) AppSpacing.vertical(context, 0.01),
                      DmPaidInvoiceTile(invoice: paidInvoices[i]),
                    ],
                  AppSpacing.vertical(context, 0.12),
                ],
              ),
            ),
          ),
          if (invoices.isNotEmpty)
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
                        label: AppTexts.dmSelectedCount(selectedCount),
                        amount: controller.selectedTotal,
                      ),
                      AppSpacing.vertical(context, 0.012),
                      AppPrimaryButton(
                        label: AppTexts.dmCollectSelected,
                        onPressed: controller.collectSelected,
                      ),
                      AppSpacing.vertical(context, 0.01),
                      AppSecondaryButton(
                        label: AppTexts.dmCollectAllOpen,
                        outlinedOnly: true,
                        onPressed: controller.collectAllOpen,
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

class _ShopCreditSection extends StatelessWidget {
  const _ShopCreditSection({required this.shop});

  final DmRecoveryShopModel shop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(shop.shopName, style: AppTextStyles.sectionTitle(context)),
        if ((shop.shopCategory ?? '').isNotEmpty) ...[
          AppSpacing.vertical(context, 0.006),
          AppStatusChip(
            label: shop.shopCategory!,
            color: AppColors.primary,
            soft: true,
          ),
        ],
        if (shop.isCreditLimitExceeded) ...[
          AppSpacing.vertical(context, 0.008),
          AppStatusChip(
            label: AppTexts.obCreditWouldExceedWarning,
            color: AppColors.warning,
            soft: true,
          ),
        ],
        AppSpacing.vertical(context, 0.012),
        AppOutlineCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AppDetailRow(
                label: AppTexts.dmEffectiveOutstanding,
                value: AppFormatter.currencyWhole(shop.effectiveOutstanding),
                valueColor: shop.isCreditLimitExceeded
                    ? AppColors.warning
                    : AppColors.primary,
                valueWeight: FontWeight.w700,
              ),
              AppDetailRow(
                label: AppTexts.dmPostedReceivable,
                value: AppFormatter.currencyWhole(shop.postedReceivable),
              ),
              AppDetailRow(
                label: AppTexts.obCreditLimitLabel.replaceAll(' (Rs)', ''),
                value: AppFormatter.currencyWhole(shop.creditLimit),
              ),
              AppDetailRow(
                label: AppTexts.obCreditRemainingLabel,
                value: AppFormatter.currencyWhole(shop.creditRemaining),
              ),
              AppDetailRow(
                label: AppTexts.dmOpenInvoices,
                value: '${shop.openInvoices.length}',
              ),
              AppDetailRow(
                label: AppTexts.dmPaidInvoices,
                value: '${shop.paidInvoiceCount}',
              ),
              AppDetailRow(
                label: AppTexts.dmShopWalletBalance,
                value: AppFormatter.currencyWhole(shop.walletBalance),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
