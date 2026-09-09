import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_approval_info.dart';

/// Non-blocking credit verification warning for order / submit surfaces.
class ObOrderCreditSection extends StatelessWidget {
  const ObOrderCreditSection({
    super.key,
    required this.approval,
    this.creditWouldExceed = false,
    this.creditLimit,
    this.outstandingBalance,
    this.creditRemaining,
    this.orderAmount,
    this.forManagerReview = false,
  });

  final ObOrderApprovalInfo approval;
  final bool creditWouldExceed;
  final double? creditLimit;
  final double? outstandingBalance;
  final double? creditRemaining;
  final double? orderAmount;
  final bool forManagerReview;

  bool get _showWarning => approval.hasCreditReason || creditWouldExceed;

  @override
  Widget build(BuildContext context) {
    if (!_showWarning &&
        creditLimit == null &&
        outstandingBalance == null &&
        creditRemaining == null &&
        orderAmount == null) {
      return const SizedBox.shrink();
    }

    final caption = AppTextStyles.caption(
      context,
    ).copyWith(color: AppColors.grey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          forManagerReview
              ? AppTexts.obCreditReviewSection
              : AppTexts.obCreditCheckSection,
          style: AppTextStyles.sectionTitle(context),
        ),
        AppSpacing.vertical(context, 0.01),
        AppOutlineCard(
          statusColor: _showWarning ? AppColors.warning : AppColors.primary,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              if (creditLimit != null)
                AppDetailRow(
                  label: AppTexts.obCreditLimitLabel.replaceAll(' (Rs)', ''),
                  value: AppFormatter.currencyWhole(creditLimit!),
                ),
              if (outstandingBalance != null)
                AppDetailRow(
                  label: AppTexts.obOutstandingBalanceLabel,
                  value: AppFormatter.currencyWhole(outstandingBalance!),
                ),
              if (creditRemaining != null)
                AppDetailRow(
                  label: AppTexts.obCreditRemainingLabel,
                  value: AppFormatter.currencyWhole(creditRemaining!),
                ),
              if (orderAmount != null)
                AppDetailRow(
                  label: AppTexts.obOrderAmountLabel,
                  value: AppFormatter.currencyWhole(orderAmount!),
                  showDivider: !_showWarning,
                ),
              if (_showWarning)
                Padding(
                  padding: AppSpacing.symmetric(context, h: 0.02, v: 0.012),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        forManagerReview
                            ? AppTexts.obCreditFlagsForManager
                            : AppTexts.obCreditFlagsInfoNote,
                        style: caption.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (creditWouldExceed || approval.hasCreditReason) ...[
                        AppSpacing.vertical(context, 0.006),
                        Text(
                          '• ${AppTexts.obCreditWouldExceedWarning}',
                          style: caption,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
