import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_line_model.dart';

class ObOrderLineTile extends StatelessWidget {
  const ObOrderLineTile({super.key, required this.line});

  final ObOrderLineModel line;

  @override
  Widget build(BuildContext context) {
    final total = line.quantity * line.unitPrice;
    return AppOutlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line.productName,
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.vertical(context, 0.006),
          Text(
            '${line.quantity} x ${AppFormatter.currencyWhole(line.unitPrice)}',
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.vertical(context, 0.006),
          Text(
            AppFormatter.currencyWhole(total),
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
