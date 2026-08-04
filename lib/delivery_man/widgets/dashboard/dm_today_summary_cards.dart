import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_status_stripe.dart';

class DmTodaySummaryCards extends StatelessWidget {
  const DmTodaySummaryCards({
    super.key,
    required this.pendingCount,
    required this.inTransitCount,
    required this.deliveredCount,
  });

  final int pendingCount;
  final int inTransitCount;
  final int deliveredCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DmSummaryMetricCard(
            label: AppTexts.deliveryStatusPending,
            value: '$pendingCount',
            stripeColor: AppColors.warning,
          ),
        ),
        AppSpacing.horizontal(context, 0.015),
        Expanded(
          child: _DmSummaryMetricCard(
            label: AppTexts.deliveryStatusInTransit,
            value: '$inTransitCount',
            stripeColor: AppColors.information,
          ),
        ),
        AppSpacing.horizontal(context, 0.015),
        Expanded(
          child: _DmSummaryMetricCard(
            label: AppTexts.deliveryStatusDelivered,
            value: '$deliveredCount',
            stripeColor: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _DmSummaryMetricCard extends StatelessWidget {
  const _DmSummaryMetricCard({
    required this.label,
    required this.value,
    required this.stripeColor,
  });

  final String label;
  final String value;
  final Color stripeColor;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppResponsive.radius(context));

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: radius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Stack(
        children: [
          AppStatusStripe(
            color: stripeColor,
            thicknessFactor: 0.008,
            edge: AppStatusStripeEdge.bottom,
          ),
          Padding(
            padding: AppSpacing.symmetric(
              context,
              h: 0.02,
              v: 0.005,
            ).copyWith(bottom: AppSpacing.verticalValue(context, 0.02)),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.heading(
                      context,
                    ).copyWith(color: AppColors.white),
                  ),
                  AppSpacing.vertical(context, 0.004),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption(context).copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
