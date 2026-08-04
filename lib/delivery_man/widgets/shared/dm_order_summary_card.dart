import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';

class DmOrderSummaryCard extends StatelessWidget {
  const DmOrderSummaryCard({super.key, required this.order});

  final DmDeliveryOrderModel order;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      statusColor: order.status.chipColor,
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.012),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.symmetric(context, h: 0.02, v: 0.006),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.deliveryNumber,
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      AppSpacing.vertical(context, 0.002),
                      Text(
                        '${AppTexts.dmOrderIdLabel}: ${order.orderNumber}',
                        style: AppTextStyles.caption(
                          context,
                        ).copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                AppStatusChip.delivery(order.status),
              ],
            ),
          ),
          AppDetailRow(label: AppTexts.dmShopLabel, value: order.shopName),
          if (order.shopAddress != null)
            AppDetailRow(
              label: AppTexts.dmAddressLabel,
              value: order.shopAddress!,
            ),
          AppDetailRow(
            label: AppTexts.dmItemsLabel,
            value: AppTexts.dmItemsCount(order.resolvedItemCount),
          ),
          if (order.resolvedTotal > 0)
            AppDetailRow(
              label: AppTexts.dmAmountLabel,
              value: AppFormatter.currencyWhole(order.resolvedTotal),
            ),
          if (order.receiverName != null && order.receiverName!.isNotEmpty)
            AppDetailRow(
              label: AppTexts.dmReceiverNameLabel,
              value: order.receiverName!,
            ),
          if (order.scheduledAt != null)
            AppDetailRow(
              label: AppTexts.dmDateLabel,
              value: AppFormatter.dayMonthYear(order.scheduledAt!),
              showDivider: false,
            ),
        ],
      ),
    );
  }
}
