import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';

class ObVisitDetailLineTile extends StatelessWidget {
  const ObVisitDetailLineTile({super.key, required this.line});

  final ObVisitCartLineModel line;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      color: AppColors.grey.withValues(alpha: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            line.productName,
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          AppSpacing.vertical(context, 0.008),
          _Row(
            label: AppTexts.obCartQuantityHint,
            value: '${line.quantity.toStringAsFixed(0)} ${line.unit ?? ''}'
                .trim(),
          ),
          AppSpacing.vertical(context, 0.006),
          _Row(
            label: AppTexts.obCartPriceHint,
            value: AppFormatter.currencyWhole(line.priceUnit),
          ),
          AppSpacing.vertical(context, 0.006),
          _Row(
            label: AppTexts.obTotalLabel,
            value: AppFormatter.currencyWhole(line.lineTotal),
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
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
