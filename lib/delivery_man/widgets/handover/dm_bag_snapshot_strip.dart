import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';

class DmBagSnapshotStrip extends StatelessWidget {
  const DmBagSnapshotStrip({
    super.key,
    required this.cashInBag,
    required this.chequeInBag,
    required this.bagTotal,
  });

  final double cashInBag;
  final double chequeInBag;
  final double bagTotal;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);
    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _Stat(
            label: AppTexts.dmBagCash,
            value: AppFormatter.compactCurrency(cashInBag),
            color: AppColors.success,
          ),
          _divider(context),
          _Stat(
            label: AppTexts.dmBagCheque,
            value: AppFormatter.compactCurrency(chequeInBag),
            color: AppColors.warning,
          ),
          _divider(context),
          _Stat(
            label: AppTexts.dmBagTotal,
            value: AppFormatter.compactCurrency(bagTotal),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: AppSpacing.verticalValue(context, 0.045),
      color: AppColors.cardBorder,
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyText(context).copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: AppResponsive.scaleSize(context, 13),
              height: 1.15,
            ),
          ),
          AppSpacing.vertical(context, 0.004),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
