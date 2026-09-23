import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_status_stripe.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_model.dart';

class ObShopCreditCard extends StatelessWidget {
  const ObShopCreditCard({
    super.key,
    required this.shop,
    this.liveOrderAmount,
    this.wouldExceedCredit = false,
  });

  final ObShopModel shop;

  /// Live cart / proposed order total for create-order screen.
  final double? liveOrderAmount;
  final bool wouldExceedCredit;

  @override
  Widget build(BuildContext context) {
    final isCredit = shop.isCreditShop;
    final remaining = shop.resolvedCreditRemaining;
    final limitExceeded = shop.isCreditLimitExceeded;
    final remainingColor = remaining != null && remaining <= 0
        ? AppColors.error
        : AppColors.success;
    final showOrderExceed =
        isCredit && (wouldExceedCredit || shop.creditWouldExceed);
    final effectiveOverLimit =
        shop.creditLimit != null &&
        shop.effectiveOutstanding != null &&
        shop.effectiveOutstanding! > shop.creditLimit!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.obShopCreditSummary,
          style: AppTextStyles.sectionTitle(context),
        ),
        AppSpacing.vertical(context, 0.008),
        AppOutlineCard(
          statusColor: shop.shopType.chipColor,
          padding: EdgeInsets.zero,
          child: AppDetailRow(
            label: AppTexts.obShopTypeLabel,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppStatusChip.shopType(shop.shopType),
                if (limitExceeded) ...[
                  AppSpacing.horizontal(context, 0.01),
                  AppStatusChip(
                    label: AppTexts.obCreditLimitExceededChip,
                    color: AppColors.error,
                    soft: true,
                  ),
                ],
              ],
            ),
            showDivider: false,
          ),
        ),
        if (isCredit && shop.creditLimit != null) ...[
          AppSpacing.vertical(context, 0.008),
          AppOutlineCard(
            statusColor: AppColors.primary,
            statusStripeEdge: AppStatusStripeEdge.bottom,
            statusStripeThicknessFactor: 0.004,
            padding: EdgeInsets.zero,
            child: AppDetailRow(
              label: AppTexts.obCreditLimitLabel.replaceAll(' (Rs)', ''),
              value: AppFormatter.currencyWhole(shop.creditLimit!),
              valueColor: AppColors.primary,
              valueWeight: FontWeight.w700,
              showDivider: false,
            ),
          ),
        ],
        if (isCredit && shop.outstandingBalance != null) ...[
          AppSpacing.vertical(context, 0.008),
          AppOutlineCard(
            statusColor: AppColors.error,
            statusStripeEdge: AppStatusStripeEdge.bottom,
            statusStripeThicknessFactor: 0.004,
            padding: EdgeInsets.zero,
            child: AppDetailRow(
              label: AppTexts.obOutstandingBalanceLabel,
              value: AppFormatter.currencyWhole(shop.outstandingBalance!),
              valueColor: AppColors.error,
              valueWeight: FontWeight.w700,
              showDivider: false,
            ),
          ),
        ],
        if (isCredit && shop.effectiveOutstanding != null) ...[
          AppSpacing.vertical(context, 0.008),
          AppOutlineCard(
            statusColor: effectiveOverLimit || limitExceeded
                ? AppColors.error
                : AppColors.warning,
            statusStripeEdge: AppStatusStripeEdge.bottom,
            statusStripeThicknessFactor: 0.004,
            padding: EdgeInsets.zero,
            child: AppDetailRow(
              label: AppTexts.obEffectiveOutstandingLabel,
              value: AppFormatter.currencyWhole(shop.effectiveOutstanding!),
              valueColor: effectiveOverLimit || limitExceeded
                  ? AppColors.error
                  : AppColors.warning,
              valueWeight: FontWeight.w700,
              showDivider: false,
            ),
          ),
        ],
        if (isCredit && remaining != null) ...[
          AppSpacing.vertical(context, 0.008),
          AppOutlineCard(
            statusColor: remainingColor,
            statusStripeEdge: AppStatusStripeEdge.bottom,
            statusStripeThicknessFactor: 0.004,
            padding: EdgeInsets.zero,
            child: AppDetailRow(
              label: AppTexts.obCreditRemainingLabel,
              value: AppFormatter.currencyWhole(remaining),
              valueColor: remainingColor,
              valueWeight: FontWeight.w700,
              showDivider: false,
            ),
          ),
        ],
        if (isCredit && liveOrderAmount != null) ...[
          AppSpacing.vertical(context, 0.008),
          AppOutlineCard(
            statusColor: showOrderExceed
                ? AppColors.warning
                : AppColors.primary,
            statusStripeEdge: AppStatusStripeEdge.bottom,
            statusStripeThicknessFactor: 0.004,
            padding: EdgeInsets.zero,
            child: AppDetailRow(
              label: AppTexts.obOrderAmountLabel,
              value: AppFormatter.currencyWhole(liveOrderAmount!),
              valueColor: showOrderExceed
                  ? AppColors.warning
                  : AppColors.primary,
              valueWeight: FontWeight.w700,
              showDivider: false,
            ),
          ),
        ],
        if (showOrderExceed && !limitExceeded) ...[
          AppSpacing.vertical(context, 0.008),
          AppOutlineCard(
            statusColor: AppColors.warning,
            child: Text(
              AppTexts.obCreditWouldExceedWarning,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.warning, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ],
    );
  }
}
