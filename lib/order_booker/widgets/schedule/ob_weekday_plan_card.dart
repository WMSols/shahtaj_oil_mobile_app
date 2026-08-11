import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/schedule/ob_weekly_schedule_model.dart';

class ObWeekdayPlanCard extends StatelessWidget {
  const ObWeekdayPlanCard({
    super.key,
    required this.day,
    this.isToday = false,
    this.onTap,
  });

  final ObWeeklyScheduleDayModel day;
  final bool isToday;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = day.isOffDay
        ? AppColors.textMuted
        : (isToday ? AppColors.primary : AppColors.primary);

    return AppOutlineCard(
      onTap: onTap,
      color: isToday && !day.isOffDay
          ? AppColors.primary.withValues(alpha: 0.06)
          : AppColors.white,
      borderColor: isToday && !day.isOffDay
          ? AppColors.primary
          : AppColors.cardBorder,
      statusColor: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  day.label,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              if (isToday)
                AppStatusChip(
                  label: AppTexts.obScheduleToday,
                  color: AppColors.primary,
                  soft: true,
                ),
            ],
          ),
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
              day.distanceKm > 0
                  ? AppTexts.obShopsDistance(
                      day.shopCount,
                      day.distanceKm.toStringAsFixed(
                        day.distanceKm == day.distanceKm.roundToDouble()
                            ? 0
                            : 1,
                      ),
                    )
                  : AppTexts.obShopsCount(day.shopCount),
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
