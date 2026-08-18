import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';

class AppAmountSummaryBar extends StatelessWidget {
  const AppAmountSummaryBar({
    super.key,
    required this.label,
    required this.amount,
  });

  final String label;
  final num amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption(context).copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
          Text(
            AppFormatter.currencyWhole(amount),
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(fontWeight: FontWeight.w800, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
