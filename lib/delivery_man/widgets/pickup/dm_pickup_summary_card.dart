import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/pickup/dm_pickup_model.dart';

class DmPickupSummaryCard extends StatelessWidget {
  const DmPickupSummaryCard({super.key, required this.pickup});

  final DmPickupModel pickup;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      statusColor: pickup.isAcknowledged
          ? AppColors.success
          : AppColors.warning,
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.012),
      child: Column(
        children: [
          AppDetailRow(
            label: AppTexts.dmWarehouse,
            value: pickup.warehouseName,
          ),
          AppDetailRow(label: AppTexts.dmVehicle, value: pickup.vehicleCode),
          AppDetailRow(
            label: AppTexts.dmShiftDate,
            value: AppFormatter.dayMonthYear(pickup.shiftDate),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
