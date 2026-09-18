import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/load/dm_load_today_model.dart';

class DmPickupSummaryCard extends StatelessWidget {
  const DmPickupSummaryCard({super.key, required this.load});

  final DmLoadTodayModel load;

  @override
  Widget build(BuildContext context) {
    final session = load.session;
    final remaining = load.pickLines.where((l) => l.qtyToPick > 0).length;
    final statusColor = session == null
        ? AppColors.grey
        : session.state.chipColor;

    return AppOutlineCard(
      statusColor: remaining > 0 ? AppColors.warning : AppColors.success,
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.012),
      child: Column(
        children: [
          if (session != null)
            AppDetailRow(
              label: AppTexts.dmVanStatusLabel,
              trailing: AppStatusChip(
                label: session.state.label,
                color: statusColor,
              ),
            ),
          if (load.date != null)
            AppDetailRow(
              label: AppTexts.dmDateLabel,
              value: AppFormatter.dayMonthYear(load.date!),
            ),
          AppDetailRow(
            label: AppTexts.dmLoadShopsCount,
            value: '${load.shops.length}',
          ),
          AppDetailRow(
            label: AppTexts.dmLoadPickRemaining,
            value: '$remaining / ${load.pickLines.length}',
          ),
          AppDetailRow(
            label: AppTexts.dmQtyOnVan,
            value: AppFormatter.targetAmount(load.vanQtyTotal),
          ),
          AppDetailRow(
            label: AppTexts.dmQtyInWarehouse,
            value: AppFormatter.targetAmount(load.warehouseQtyTotal),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
