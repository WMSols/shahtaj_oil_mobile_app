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
  });

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppTexts.obTasksProgress(completed, total),
                style: AppTextStyles.bodyText(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.grey),
            ),
          ],
        ),
        AppSpacing.vertical(context, 0.008),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: AppSpacing.verticalValue(context, 0.008),
            backgroundColor: AppColors.lightGrey,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
