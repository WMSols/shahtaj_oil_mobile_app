import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';

class DmTodaySnapshotStrip extends StatelessWidget {
  const DmTodaySnapshotStrip({
    super.key,
    required this.pendingCount,
    required this.inTransitCount,
    required this.deliveredCount,
    required this.collectedToday,
    required this.walletBalance,
    required this.settledTotal,
    this.onPendingTap,
    this.onInTransitTap,
    this.onDeliveredTap,
    this.onCollectedTap,
    this.onWalletTap,
    this.onSettledTap,
  });

  final int pendingCount;
  final int inTransitCount;
  final int deliveredCount;
  final double collectedToday;
  final double walletBalance;
  final double settledTotal;
  final VoidCallback? onPendingTap;
  final VoidCallback? onInTransitTap;
  final VoidCallback? onDeliveredTap;
  final VoidCallback? onCollectedTap;
  final VoidCallback? onWalletTap;
  final VoidCallback? onSettledTap;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);
    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.012, v: 0.012),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GroupLabel(text: AppTexts.navDeliveries),
          AppSpacing.vertical(context, 0.006),
          Row(
            children: [
              _Stat(
                label: AppTexts.deliveryStatusPending,
                value: '$pendingCount',
                color: AppColors.warning,
                onTap: onPendingTap,
              ),
              _divider(context),
              _Stat(
                label: AppTexts.deliveryStatusInTransit,
                value: '$inTransitCount',
                color: AppColors.information,
                onTap: onInTransitTap,
              ),
              _divider(context),
              _Stat(
                label: AppTexts.deliveryStatusDelivered,
                value: '$deliveredCount',
                color: AppColors.success,
                onTap: onDeliveredTap,
              ),
            ],
          ),
          Padding(
            padding: AppSpacing.symmetric(context, v: 0.01),
            child: const Divider(height: 1, color: AppColors.cardBorder),
          ),
          _GroupLabel(text: AppTexts.navCollections),
          AppSpacing.vertical(context, 0.006),
          Row(
            children: [
              _Stat(
                label: AppTexts.dmSnapshotCollected,
                value: AppFormatter.compactCurrency(collectedToday),
                color: AppColors.success,
                onTap: onCollectedTap,
              ),
              _divider(context),
              _Stat(
                label: AppTexts.dmWalletBalance,
                value: AppFormatter.compactCurrency(walletBalance),
                color: AppColors.primary,
                onTap: onWalletTap,
              ),
              _divider(context),
              _Stat(
                label: AppTexts.dmWalletSettledTotal,
                value: AppFormatter.compactCurrency(settledTotal),
                color: AppColors.grey,
                onTap: onSettledTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: AppSpacing.verticalValue(context, 0.05),
      color: AppColors.cardBorder,
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(context, h: 0.006),
      child: Text(
        text,
        style: AppTextStyles.caption(
          context,
        ).copyWith(color: AppColors.grey, fontWeight: FontWeight.w700),
      ),
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
                  padding: AppSpacing.symmetric(context, h: 0.006, v: 0.006),
                  child: content,
                ),
              ),
            ),
    );
  }
}
