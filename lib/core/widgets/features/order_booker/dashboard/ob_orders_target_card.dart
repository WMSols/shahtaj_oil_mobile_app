import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_targets_model.dart';

class ObOrdersTargetCard extends StatelessWidget {
  const ObOrdersTargetCard({super.key, required this.targets});

  final ObTargetsModel targets;

  @override
  Widget build(BuildContext context) {
    final progress = targets.ordersTarget == 0
        ? 0.0
        : targets.ordersCurrent / targets.ordersTarget;

    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      margin: EdgeInsets.only(top: AppSpacing.verticalValue(context, 0.01)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.obOrdersToday,
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(color: AppColors.white.withValues(alpha: 0.75)),
          ),
          AppSpacing.vertical(context, 0.006),
          Text(
            '${targets.ordersCurrent} / ${targets.ordersTarget}',
            style: AppTextStyles.heading(
              context,
            ).copyWith(color: AppColors.white, fontWeight: FontWeight.w700),
          ),
          AppSpacing.vertical(context, 0.012),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
            child: LinearProgressIndicator(
              minHeight: AppSpacing.verticalValue(context, 0.005),
              value: progress.clamp(0, 1),
              backgroundColor: AppColors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
