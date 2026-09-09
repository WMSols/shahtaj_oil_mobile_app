import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/visit/ob_order_create_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_approval_info.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/orders/ob_order_credit_section.dart';

class ObOrderSubmitSummaryCard extends StatelessWidget {
  const ObOrderSubmitSummaryCard({super.key, required this.controller});

  final ObOrderCreateController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final preview = controller.submitPreview;
      if (preview == null) return const SizedBox.shrink();

      final shop = controller.shop.value;
      final isCreditShop = shop?.isCreditShop == true;
      final metricStyle = AppTextStyles.caption(
        context,
      ).copyWith(color: AppColors.grey);

      return AppOutlineCard(
        statusColor: preview.needsVerification
            ? AppColors.warning
            : AppColors.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppTexts.obOrderSubmitSummaryTitle,
                    style: AppTextStyles.sectionTitle(context),
                  ),
                ),
              ],
            ),
            if (preview.hasDiscount || preview.hasCreditWarning) ...[
              AppSpacing.vertical(context, 0.008),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (preview.hasDiscount)
                    AppStatusChip(
                      label: AppTexts.obApprovalReasonDiscount,
                      color: AppColors.warning,
                      soft: true,
                    ),
                  if (preview.hasCreditWarning)
                    AppStatusChip(
                      label: AppTexts.obApprovalReasonCredit,
                      color: AppColors.warning,
                      soft: true,
                    ),
                ],
              ),
            ],
            AppSpacing.vertical(context, 0.008),
            _MetricRow(
              label: AppTexts.obAppRateTotal,
              value: AppFormatter.currencyWhole(preview.appTotal),
              style: metricStyle,
            ),
            _MetricRow(
              label: AppTexts.obProposedTotal,
              value: AppFormatter.currencyWhole(preview.proposedTotal),
              style: metricStyle,
            ),
            if (preview.discountTotal > 0)
              _MetricRow(
                label: AppTexts.obDiscountTotal,
                value: AppFormatter.currencyWhole(preview.discountTotal),
                style: metricStyle.copyWith(color: AppColors.warning),
              ),
            if (isCreditShop) ...[
              AppSpacing.vertical(context, 0.008),
              ObOrderCreditSection(
                approval: ObOrderApprovalInfo.empty,
                creditWouldExceed: preview.hasCreditWarning,
                creditLimit: shop?.creditLimit,
                outstandingBalance: shop?.outstandingBalance,
                creditRemaining: shop?.resolvedCreditRemaining,
                orderAmount: preview.proposedTotal,
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.style,
  });

  final String label;
  final String value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSpacing.verticalValue(context, 0.004),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            value,
            style: style.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
