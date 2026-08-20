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
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_shop_summary_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_shop_invoices_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_shop_due_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/collections/rm_invoice_tile.dart';

class RmShopOutstandingContent extends GetView<RmShopInvoicesController> {
  const RmShopOutstandingContent({super.key});

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
          subtitle: AppTexts.rmShopOutstandingTitle,
          image: AppImages.emptyNotFound,
          onRefresh: () => controller.loadOutstanding(force: true),
        );
      }

      final invoices = controller.invoices;
      final selectedCount = controller.selectedInvoiceIds.length;
      final isPartial = controller.isPartial;

      return Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.loadOutstanding(force: true),
              child: ListView(
                padding: AppSpacing.screenPadding(context),
                children: [
                  AppShopSummaryCard(
                    name: shop.name,
                    ownerName: shop.ownerName,
                    phone: shop.phone,
                    statusColor: shop.hasHighDue
                        ? AppColors.warning
                        : isPartial
                        ? AppColors.information
                        : AppColors.primary,
                    callLabel: AppTexts.rmCallShop,
                    directionsLabel: AppTexts.rmDirections,
                    onCall: controller.callShop,
                    onDirections: controller.openDirections,
                  ),
                  AppSpacing.vertical(context, 0.025),
                  _ShopDetailsSection(
                    shop: shop,
                    isPartial: isPartial,
                    outstanding: controller.totalOutstanding,
                    openInvoiceCount: invoices.length,
                  ),
                  AppSpacing.vertical(context, 0.025),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppTexts.rmOpenInvoices,
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
                                ? AppTexts.rmDeselectAll
                                : AppTexts.rmSelectAll,
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
                      subtitle: AppTexts.rmNoOpenInvoicesSubtitle,
                      image: AppImages.emptyNoInvoices,
                    )
                  else
                    for (var i = 0; i < invoices.length; i++) ...[
                      if (i > 0) AppSpacing.vertical(context, 0.01),
                      RmInvoiceTile(
                        invoice: invoices[i],
                        selected: controller.isSelected(invoices[i].id),
                        onTap: () => controller.toggleInvoice(invoices[i].id),
                      ),
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
                        label: AppTexts.rmSelectedCount(selectedCount),
                        amount: controller.selectedTotal,
                      ),
                      AppSpacing.vertical(context, 0.012),
                      AppPrimaryButton(
                        label: AppTexts.rmCollectSelected,
                        onPressed: controller.collectSelected,
                      ),
                      AppSpacing.vertical(context, 0.01),
                      AppSecondaryButton(
                        label: AppTexts.rmBatchPayment,
                        outlinedOnly: true,
                        onPressed: controller.collectBatch,
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

class _ShopDetailsSection extends StatelessWidget {
  const _ShopDetailsSection({
    required this.shop,
    required this.isPartial,
    required this.outstanding,
    required this.openInvoiceCount,
  });

  final RmShopDueModel shop;
  final bool isPartial;
  final double outstanding;
  final int openInvoiceCount;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      if (shop.hasHighDue)
        AppStatusChip(label: AppTexts.rmHighDueChip, color: AppColors.warning),
      if (isPartial)
        AppStatusChip(
          label: AppTexts.rmPartialChip,
          color: AppColors.information,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.obShopDetailsSection,
          style: AppTextStyles.sectionTitle(context),
        ),
        AppSpacing.vertical(context, 0.01),
        AppOutlineCard(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AppDetailRow(label: AppTexts.obShopNameLabel, value: shop.name),
              if (shop.ownerName.trim().isNotEmpty)
                AppDetailRow(
                  label: AppTexts.obOwnerNameLabel,
                  value: shop.ownerName,
                ),
              if (shop.phone.trim().isNotEmpty)
                AppDetailRow(
                  label: AppTexts.obPhoneNumberLabel,
                  value: shop.phone,
                ),
              if (shop.address.trim().isNotEmpty)
                AppDetailRow(
                  label: AppTexts.obAddressLabel,
                  value: shop.address,
                ),
              AppDetailRow(
                label: AppTexts.rmOpenInvoices,
                value: '$openInvoiceCount',
              ),
              if (chips.isNotEmpty)
                AppDetailRow(
                  label: AppTexts.rmDueStatusLabel,
                  trailing: Wrap(
                    spacing: AppSpacing.horizontalValue(context, 0.012),
                    runSpacing: AppSpacing.verticalValue(context, 0.006),
                    children: chips,
                  ),
                ),
              AppDetailRow(
                label: AppTexts.rmTotalOutstanding,
                value: AppFormatter.currencyWhole(outstanding),
                valueColor: shop.hasHighDue
                    ? AppColors.warning
                    : AppColors.primary,
                valueWeight: FontWeight.w700,
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
