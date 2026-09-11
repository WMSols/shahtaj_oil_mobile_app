import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_line_model.dart';

/// Extra approval details only (status chip lives once on the order header).
class ObOrderApprovalSection extends StatelessWidget {
  const ObOrderApprovalSection({super.key, required this.order});

  final ObOrderDetailModel order;

  @override
  Widget build(BuildContext context) {
    if (!order.showsApprovalSection) return const SizedBox.shrink();

    final approval = order.approval;
    final caption = AppTextStyles.caption(
      context,
    ).copyWith(color: AppColors.grey);
    final discountedLines = order.lines
        .where((line) => line.isDiscounted)
        .toList(growable: false);

    final hasDetailRows =
        approval.reasons.isNotEmpty ||
        order.discountTotal > 0 ||
        approval.verifiedAt != null ||
        (approval.rejectionReason != null &&
            approval.rejectionReason!.trim().isNotEmpty);

    if (!hasDetailRows && discountedLines.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.obOrderApprovalSection,
          style: AppTextStyles.sectionTitle(context),
        ),
        AppSpacing.vertical(context, 0.01),
        if (hasDetailRows)
          AppOutlineCard(
            statusColor: approval.state.chipColor,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                if (approval.reasons.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.horizontalValue(context, 0.04),
                      AppSpacing.verticalValue(context, 0.012),
                      AppSpacing.horizontalValue(context, 0.04),
                      AppSpacing.verticalValue(context, 0.008),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTexts.obApprovalReasonsLabel,
                          style: AppTextStyles.caption(
                            context,
                          ).copyWith(color: AppColors.grey),
                        ),
                        AppSpacing.vertical(context, 0.006),
                        Wrap(
                          spacing: AppSpacing.horizontalValue(context, 0.02),
                          runSpacing: AppSpacing.verticalValue(context, 0.006),
                          children: [
                            for (final reason in approval.reasons)
                              AppStatusChip(
                                label: reason.label,
                                color: reason.chipColor,
                                soft: true,
                              ),
                          ],
                        ),
                        if (order.discountTotal > 0 ||
                            approval.verifiedAt != null ||
                            approval.rejectionReason != null)
                          Padding(
                            padding: EdgeInsets.only(
                              top: AppSpacing.verticalValue(context, 0.01),
                            ),
                            child: const Divider(height: 1),
                          ),
                      ],
                    ),
                  ),
                if (order.discountTotal > 0)
                  AppDetailRow(
                    label: AppTexts.obDiscountTotal,
                    value: AppFormatter.currencyWhole(order.discountTotal),
                    showDivider:
                        approval.verifiedAt != null ||
                        approval.rejectionReason != null,
                  ),
                if (approval.verifiedAt != null)
                  AppDetailRow(
                    label: AppTexts.obVerifiedAtLabel,
                    value: AppFormatter.dateTime(approval.verifiedAt!),
                    showDivider: approval.rejectionReason != null,
                  ),
                if (approval.rejectionReason != null &&
                    approval.rejectionReason!.trim().isNotEmpty)
                  AppDetailRow(
                    label: AppTexts.obRejectionReason,
                    value: approval.rejectionReason!,
                    showDivider: false,
                  ),
              ],
            ),
          ),
        if (discountedLines.isNotEmpty) ...[
          AppSpacing.vertical(context, 0.012),
          for (final line in discountedLines) ...[
            _LineRateCard(line: line, caption: caption),
            AppSpacing.vertical(context, 0.008),
          ],
        ],
      ],
    );
  }
}

class _LineRateCard extends StatelessWidget {
  const _LineRateCard({required this.line, required this.caption});

  final ObOrderLineModel line;
  final TextStyle caption;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(line.productName, style: AppTextStyles.sectionTitle(context)),
          AppSpacing.vertical(context, 0.004),
          Text(
            '${AppTexts.obAppRateLabel}: ${AppFormatter.currencyWhole(line.appRate)}',
            style: caption,
          ),
          Text(
            '${AppTexts.obProposedRateLabel}: ${AppFormatter.currencyWhole(line.proposedRate)}',
            style: caption,
          ),
          if (line.isDiscounted)
            Text(
              '${AppTexts.obRateVariance}: ${AppFormatter.currencyWhole(line.appRate - line.proposedRate)}',
              style: caption.copyWith(color: AppColors.warning),
            ),
        ],
      ),
    );
  }
}
