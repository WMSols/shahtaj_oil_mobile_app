import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';

/// Compact product line summary used by order and visit detail screens.
class AppLineSummaryTile extends StatelessWidget {
  const AppLineSummaryTile({
    super.key,
    required this.title,
    required this.quantityLabel,
    required this.unitPrice,
    required this.lineTotal,
    this.emphasized = false,
    this.mutedBackground = false,
    this.quantityCaption,
    this.priceCaption,
    this.totalCaption,
  });

  final String title;
  final String quantityLabel;
  final double unitPrice;
  final double lineTotal;
  final bool emphasized;
  final bool mutedBackground;
  final String? quantityCaption;
  final String? priceCaption;
  final String? totalCaption;

  @override
  Widget build(BuildContext context) {
    final hasLabeledRows =
        quantityCaption != null && priceCaption != null && totalCaption != null;

    return AppOutlineCard(
      color: mutedBackground
          ? AppColors.grey.withValues(alpha: 0.08)
          : AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyText(context).copyWith(
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          AppSpacing.vertical(context, 0.006),
          if (hasLabeledRows) ...[
            _LabeledRow(label: quantityCaption!, value: quantityLabel),
            AppSpacing.vertical(context, 0.006),
            _LabeledRow(
              label: priceCaption!,
              value: AppFormatter.currencyWhole(unitPrice),
            ),
            AppSpacing.vertical(context, 0.006),
            _LabeledRow(
              label: totalCaption!,
              value: AppFormatter.currencyWhole(lineTotal),
              emphasized: true,
            ),
          ] else ...[
            Text(
              quantityLabel,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.textMuted),
            ),
            AppSpacing.vertical(context, 0.006),
            Text(
              AppFormatter.currencyWhole(lineTotal),
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ],
        ],
      ),
    );
  }
}

class _LabeledRow extends StatelessWidget {
  const _LabeledRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: AppColors.grey, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyText(context).copyWith(
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
            color: emphasized ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
