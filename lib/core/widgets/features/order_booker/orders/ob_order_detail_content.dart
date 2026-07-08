import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/orders/ob_order_line_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_order_detail_controller.dart';

class ObOrderDetailContent extends GetView<ObOrderDetailController> {
  const ObOrderDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    final order = controller.order.value!;
    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: AppSpacing.screenPadding(context),
        children: [
          AppOutlineCard(
            statusColor: order.status.chipColor,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppDetailRow(
                  label: AppTexts.obOrderNumberLabel,
                  value: order.orderNumber,
                ),
                AppDetailRow(
                  label: AppTexts.obShopNameLabel,
                  value: order.shopName,
                ),
                AppDetailRow(
                  label: AppTexts.obVisitOutcomeLabel,
                  trailing: AppStatusChip.order(order.status),
                  showDivider: false,
                ),
              ],
            ),
          ),
          AppSpacing.vertical(context, 0.02),
          Text(
            AppTexts.obVisitLinesSection,
            style: AppTextStyles.sectionTitle(context),
          ),
          AppSpacing.vertical(context, 0.01),
          ...order.lines.map(
            (line) => Padding(
              padding: EdgeInsets.only(
                bottom: AppSpacing.verticalValue(context, 0.01),
              ),
              child: ObOrderLineTile(line: line),
            ),
          ),
          AppSpacing.vertical(context, 0.005),
          AppDetailRow(
            label: AppTexts.obSubtotal,
            value: AppFormatter.currencyWhole(order.subtotal),
            showDivider: false,
          ),
          if (order.visitId != null) ...[
            AppSpacing.vertical(context, 0.02),
            AppSecondaryButton(
              label: AppTexts.obVisitDetailTitle,
              outlinedOnly: true,
              onPressed: controller.openVisit,
            ),
          ],
        ],
      ),
    );
  }
}
