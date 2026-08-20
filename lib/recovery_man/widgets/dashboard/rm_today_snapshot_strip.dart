import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';

class RmTodaySnapshotStrip extends StatelessWidget {
  const RmTodaySnapshotStrip({
    super.key,
    required this.collectedToday,
    required this.stillDue,
    required this.cashInBag,
    this.onCollectedTap,
    this.onStillDueTap,
    this.onCashInBagTap,
  });

  final double collectedToday;
  final double stillDue;
  final double cashInBag;
  final VoidCallback? onCollectedTap;
  final VoidCallback? onStillDueTap;
  final VoidCallback? onCashInBagTap;

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
            label: AppTexts.rmSnapshotCollected,
            value: AppFormatter.compactCurrency(collectedToday),
            color: AppColors.success,
            onTap: onCollectedTap,
          ),
          _divider(context),
          _Stat(
            label: AppTexts.rmSnapshotStillDue,
            value: AppFormatter.compactCurrency(stillDue),
            color: AppColors.warning,
            onTap: onStillDueTap,
          ),
          _divider(context),
          _Stat(
            label: AppTexts.rmSnapshotCashInBag,
            value: AppFormatter.compactCurrency(cashInBag),
            color: AppColors.primary,
            onTap: onCashInBagTap,
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
  const _Stat({
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
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
    );

    return Expanded(
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context),
                ),
                child: Padding(
                  padding: AppSpacing.symmetric(context, h: 0.008, v: 0.006),
                  child: content,
                ),
              ),
            ),
    );
  }
}
