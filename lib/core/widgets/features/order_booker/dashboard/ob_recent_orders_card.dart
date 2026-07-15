import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_summary_model.dart';

class ObRecentOrdersCard extends StatelessWidget {
  const ObRecentOrdersCard({super.key, required this.orders, this.onOrderTap});

  final List<ObOrderSummaryModel> orders;
  final ValueChanged<ObOrderSummaryModel>? onOrderTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < orders.length; index++) ...[
          if (index > 0) AppSpacing.vertical(context, 0.01),
          _RecentOrderRow(
            order: orders[index],
            onTap: onOrderTap == null ? null : () => onOrderTap!(orders[index]),
          ),
        ],
      ],
    );
  }
}

class _RecentOrderRow extends StatelessWidget {
  const _RecentOrderRow({required this.order, this.onTap});

  final ObOrderSummaryModel order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      onTap: onTap,
      statusColor: order.status.chipColor,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.015),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderNumber,
                  style: AppTextStyles.sectionTitle(context),
                ),
                Text(
                  order.shopName,
                  style: AppTextStyles.bodyText(
                    context,
                  ).copyWith(color: AppColors.grey),
                ),
                AppSpacing.vertical(context, 0.006),
                AppStatusChip.visitOutcome(VisitOutcome.orderPlaced),
              ],
            ),
          ),
          Text(
            AppFormatter.currency(order.amount, symbol: 'Rs. '),
            style: AppTextStyles.sectionTitle(context),
          ),
        ],
      ),
    );
  }
}
