import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van_stock/dm_van_stock_model.dart';

class DmVanStockSummaryCard extends StatelessWidget {
  const DmVanStockSummaryCard({super.key, required this.session});

  final DmVanStockModel session;

  @override
  Widget build(BuildContext context) {
    final statusColor = session.isUnloaded
        ? AppColors.success
        : session.isLoaded
        ? AppColors.primary
        : AppColors.warning;
    final statusLabel = session.isUnloaded
        ? AppTexts.dmVanStatusUnloaded
        : session.isLoaded
        ? AppTexts.dmVanStatusLoaded
        : AppTexts.dmVanStatusNotLoaded;

    return AppOutlineCard(
      statusColor: statusColor,
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.012),
      child: Column(
        children: [
          AppDetailRow(
            label: AppTexts.dmWarehouse,
            value: session.warehouseName,
          ),
          AppDetailRow(label: AppTexts.dmVehicle, value: session.vehicleCode),
          AppDetailRow(
            label: AppTexts.dmShiftDate,
            value: AppFormatter.dayMonthYear(session.shiftDate),
          ),
          AppDetailRow(
            label: AppTexts.dmVanStatusLabel,
            trailing: AppStatusChip(label: statusLabel, color: statusColor),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
