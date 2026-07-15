import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_weekly_schedule_model.dart';

class ObWeekdayPlanCard extends StatelessWidget {
  const ObWeekdayPlanCard({super.key, required this.day});

  final ObWeeklyScheduleDayModel day;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      statusColor: day.isOffDay ? AppColors.textMuted : AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day.label, style: AppTextStyles.sectionTitle(context)),
          AppSpacing.vertical(context, 0.006),
          if (day.isOffDay)
            Text(
              AppTexts.notAvailable,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.textMuted),
            )
          else ...[
            Text(
              day.routeName ?? '-',
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            AppSpacing.vertical(context, 0.003),
            Text(
              AppTexts.obShopsCount(day.shopCount),
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.textMuted),
            ),
            if (day.zoneName != null) ...[
              AppSpacing.vertical(context, 0.003),
              Text(
                day.zoneName!,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: AppColors.primary),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
