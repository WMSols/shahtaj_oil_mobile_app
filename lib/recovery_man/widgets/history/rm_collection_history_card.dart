import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_summary_model.dart';

class RmCollectionHistoryCard extends StatelessWidget {
  const RmCollectionHistoryCard({
    super.key,
    required this.collection,
    required this.timeLabel,
    this.onTap,
  });

  final RmCollectionSummaryModel collection;
  final String timeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(
      context,
    ).copyWith(color: AppColors.grey);

    return AppOutlineCard(
      onTap: onTap,
      statusColor: collection.status.chipColor,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: receipt number | payment chip | chevron
          Row(
            children: [
              Expanded(
                child: Text(
                  collection.receiptNumber,
                  style: AppTextStyles.sectionTitle(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppSpacing.horizontal(context, 0.012),
              AppStatusChip.paymentMethod(collection.method),
              AppSpacing.horizontal(context, 0.012),
              Icon(
                AppIcons.chevronRight,
                color: AppColors.black,
                size: AppResponsive.scaleSize(context, 22),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.004),
          Text(collection.shopName, style: mutedStyle),
          AppSpacing.vertical(context, 0.006),
          // Time row
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
          AppSpacing.vertical(context, 0.008),
          // Bottom row: amount | collection status chip
          Row(
            children: [
              Text(
                AppFormatter.currency(collection.amount, symbol: 'Rs. '),
                style: AppTextStyles.sectionTitle(
                  context,
                ).copyWith(color: AppColors.primary),
              ),
              AppSpacing.horizontal(context, 0.016),
              AppStatusChip.collection(collection.status),
            ],
          ),
        ],
      ),
    );
  }
}
