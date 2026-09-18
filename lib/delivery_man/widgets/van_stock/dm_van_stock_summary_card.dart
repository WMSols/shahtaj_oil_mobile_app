import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_snapshot_model.dart';

class DmVanStockSummaryCard extends StatelessWidget {
  const DmVanStockSummaryCard({super.key, required this.snapshot});

  final DmVanSnapshotModel snapshot;

  @override
  Widget build(BuildContext context) {
    final hasStock = snapshot.qtyTotal > 0 || snapshot.items.isNotEmpty;
    return AppOutlineCard(
      statusColor: hasStock ? AppColors.primary : AppColors.warning,
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.012),
      child: Column(
        children: [
          AppDetailRow(
            label: AppTexts.dmVanStockItems,
            value: '${snapshot.items.length}',
          ),
          AppDetailRow(
            label: AppTexts.dmQtyOnVan,
            value: AppFormatter.targetAmount(snapshot.qtyTotal),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
