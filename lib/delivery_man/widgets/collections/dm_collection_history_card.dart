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
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_collection_model.dart';

class DmCollectionHistoryCard extends StatelessWidget {
  const DmCollectionHistoryCard({
    super.key,
    required this.collection,
    required this.timeLabel,
    this.onTap,
  });

  final DmWalletCollectionModel collection;
  final String timeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(
      context,
    ).copyWith(color: AppColors.grey);

    return AppOutlineCard(
      onTap: onTap,
      statusColor: collection.isWalkIn
          ? AppColors.statPurple
          : collection.paymentMethod.chipColor,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  collection.name,
                  style: AppTextStyles.sectionTitle(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (collection.isWalkIn) ...[
                AppStatusChip.walkIn(soft: true),
                AppSpacing.horizontal(context, 0.01),
              ],
              AppStatusChip(
                label: collection.paymentMethod.label,
                color: collection.paymentMethod.chipColor,
                soft: true,
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.004),
          Text(collection.shopName, style: mutedStyle),
          if (collection.invoices.isNotEmpty) ...[
            AppSpacing.vertical(context, 0.004),
            Text(
              collection.invoices.join(', '),
              style: mutedStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (collection.paymentMethod == PaymentMethod.cheque &&
              (collection.chequeNumber ?? '').isNotEmpty) ...[
            AppSpacing.vertical(context, 0.004),
            Text(collection.chequeNumber!, style: mutedStyle),
          ],
          if ((collection.notes ?? '').isNotEmpty) ...[
            AppSpacing.vertical(context, 0.004),
            Text(collection.notes!, style: mutedStyle),
          ],
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
              Text(
                AppFormatter.currency(collection.amount, symbol: 'Rs. '),
                style: AppTextStyles.sectionTitle(
                  context,
                ).copyWith(color: AppColors.primary),
              ),
              if (onTap != null) ...[
                AppSpacing.horizontal(context, 0.01),
                Icon(
                  AppIcons.chevronRight,
                  color: AppColors.black,
                  size: AppResponsive.scaleSize(context, 20),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
