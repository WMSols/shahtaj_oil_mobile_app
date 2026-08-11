import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_targets_model.dart';

class ObOrdersTargetCard extends StatelessWidget {
  const ObOrdersTargetCard({super.key, required this.targets, this.onTap});

  final ObTargetsModel targets;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = targets.headlinePercent / 100;

    final content = Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.obTargetsProgressPercent(targets.headlinePercent),
            style: AppTextStyles.headline(
              context,
            ).copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
          ),
          AppSpacing.vertical(context, 0.004),
          Text(
            AppTexts.obTargetsDashboardSummary,
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(color: AppColors.white.withValues(alpha: 0.9)),
          ),
          if (targets.topHighlights.isNotEmpty) ...[
            AppSpacing.vertical(context, 0.008),
            for (final item in targets.topHighlights)
              Padding(
                padding: EdgeInsets.only(
                  bottom: AppSpacing.verticalValue(context, 0.003),
                ),
                child: Text(
                  item.dashboardLine,
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: AppColors.white.withValues(alpha: 0.9)),
                ),
              ),
          ],
          AppSpacing.vertical(context, 0.01),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
            child: LinearProgressIndicator(
              minHeight: AppSpacing.verticalValue(context, 0.01),
              value: progress.clamp(0, 1),
              backgroundColor: AppColors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
