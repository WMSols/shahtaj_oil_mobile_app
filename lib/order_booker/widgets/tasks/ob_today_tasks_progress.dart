import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class ObTodayTasksProgress extends StatelessWidget {
  const ObTodayTasksProgress({
    super.key,
    required this.completed,
    required this.total,
    this.onPrimary = false,
  });

  final int completed;
  final int total;

  /// Light text / track for use on solid primary surfaces.
  final bool onPrimary;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    final labelColor = onPrimary ? AppColors.white : AppColors.textPrimary;
    final percentColor = onPrimary
        ? AppColors.white.withValues(alpha: 0.85)
        : AppColors.grey;
    final trackColor = onPrimary
        ? AppColors.white.withValues(alpha: 0.25)
        : AppColors.lightGrey;
    final barColor = onPrimary ? AppColors.white : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppTexts.obTasksProgress(completed, total),
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(fontWeight: FontWeight.w600, color: labelColor),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: percentColor),
            ),
          ],
        ),
        AppSpacing.vertical(context, 0.008),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: AppSpacing.verticalValue(context, 0.008),
            backgroundColor: trackColor,
            color: barColor,
          ),
        ),
      ],
    );
  }
}
