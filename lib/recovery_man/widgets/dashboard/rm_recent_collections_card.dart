import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_summary_model.dart';

class RmRecentCollectionsCard extends StatelessWidget {
  const RmRecentCollectionsCard({
    super.key,
    required this.collections,
    this.onCollectionTap,
  });

  final List<RmCollectionSummaryModel> collections;
  final ValueChanged<RmCollectionSummaryModel>? onCollectionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < collections.length; index++) ...[
          if (index > 0) AppSpacing.vertical(context, 0.01),
          _RecentCollectionRow(
            collection: collections[index],
            onTap: onCollectionTap == null
                ? null
                : () => onCollectionTap!(collections[index]),
          ),
        ],
      ],
    );
  }
}

class _RecentCollectionRow extends StatelessWidget {
  const _RecentCollectionRow({required this.collection, this.onTap});

  final RmCollectionSummaryModel collection;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      onTap: onTap,
      statusColor: collection.method.chipColor,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.015),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collection.receiptNumber,
                  style: AppTextStyles.sectionTitle(context),
                ),
                Text(
                  collection.shopName,
                  style: AppTextStyles.bodyText(
                    context,
                  ).copyWith(color: AppColors.grey),
                ),
                AppSpacing.vertical(context, 0.006),
                AppStatusChip.paymentMethod(collection.method),
              ],
            ),
          ),
          Text(
            AppFormatter.currency(collection.amount, symbol: 'Rs. '),
            style: AppTextStyles.sectionTitle(context),
          ),
        ],
      ),
    );
  }
}
