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
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_summary_model.dart';

class ObVisitHistoryCard extends StatelessWidget {
  const ObVisitHistoryCard({
    super.key,
    required this.visit,
    required this.timeLabel,
    this.onTap,
  });

  final ObVisitSummaryModel visit;
  final String timeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(context).copyWith(
      color: AppColors.black,
      fontSize: AppResponsive.scaleSize(context, 13),
    );

    return AppOutlineCard(
      onTap: onTap,
      statusColor: visit.outcome.chipColor,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        visit.shopName,
                        style: AppTextStyles.sectionTitle(context),
                      ),
                    ),
                    AppStatusChip.visitOutcome(visit.outcome),
                  ],
                ),
                if (visit.ownerName != null) ...[
                  AppSpacing.vertical(context, 0.005),
                  Text(
                    AppTexts.obShopOwner(visit.ownerName!),
                    style: mutedStyle,
                  ),
                ],
                AppSpacing.vertical(context, 0.005),
                Row(
                  children: [
                    Icon(
                      AppIcons.history5,
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
                if (visit.subtotal != null && visit.subtotal! > 0) ...[
                  AppSpacing.vertical(context, 0.008),
                  Text(
                    AppFormatter.currencyWhole(visit.subtotal!),
                    style: AppTextStyles.bodyText(context).copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            AppIcons.chevronRight,
            color: AppColors.black,
            size: AppResponsive.scaleSize(context, 22),
          ),
        ],
      ),
    );
  }
}
