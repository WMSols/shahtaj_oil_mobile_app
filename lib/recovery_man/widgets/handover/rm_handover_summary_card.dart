import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/handover/rm_handover_summary_model.dart';

class RmHandoverSummaryCard extends StatelessWidget {
  const RmHandoverSummaryCard({
    super.key,
    required this.handover,
    required this.timeLabel,
    this.onTap,
  });

  final RmHandoverSummaryModel handover;
  final String timeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(
      context,
    ).copyWith(color: AppColors.grey);

    return AppOutlineCard(
      onTap: onTap,
      statusColor: handover.status.chipColor,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        handover.reference,
                        style: AppTextStyles.sectionTitle(context),
                      ),
                    ),
                    AppStatusChip.handover(handover.status),
                  ],
                ),
                AppSpacing.vertical(context, 0.004),
                Text(
                  AppFormatter.currencyWhole(handover.total),
                  style: AppTextStyles.sectionTitle(context),
                ),
                AppSpacing.vertical(context, 0.002),
                Text(
                  AppTexts.rmHandoverReceiptsCount(handover.collectionCount),
                  style: mutedStyle,
                ),
                AppSpacing.vertical(context, 0.006),
                Row(
                  children: [
                    Icon(
                      AppIcons.calendar,
                      size: AppResponsive.iconSize(context, factor: 0.8),
                      color: AppColors.primary,
                    ),
                    AppSpacing.horizontal(context, 0.01),
                    Expanded(
                      child: Text(
                        timeLabel,
                        style: mutedStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            AppIcons.chevronRight,
            color: AppColors.black,
            size: AppResponsive.scaleSize(context, 20),
          ),
        ],
      ),
    );
  }
}
