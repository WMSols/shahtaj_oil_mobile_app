import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';

class DmOrderCard extends StatelessWidget {
  const DmOrderCard({super.key, required this.order, this.onTap});

  final DmDeliveryOrderModel order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(context).copyWith(
      color: AppColors.black,
      fontSize: AppResponsive.scaleSize(context, 13),
    );

    return AppOutlineCard(
      onTap: onTap,
      statusColor: order.status.chipColor,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                            style: mutedStyle.copyWith(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                    AppStatusChip.delivery(order.status),
                  ],
                ),
                AppSpacing.vertical(context, 0.005),
                Text(order.shopName, style: mutedStyle),
                if (order.shopAddress != null) ...[
                  AppSpacing.vertical(context, 0.005),
                  Row(
                    children: [
                      Icon(
                        AppIcons.location5,
                        size: AppResponsive.iconSize(context, factor: 0.8),
                        color: AppColors.primary,
                      ),
                      AppSpacing.horizontal(context, 0.01),
                      Flexible(
                        child: Text(
                          order.shopAddress!,
                          style: mutedStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                AppSpacing.vertical(context, 0.005),
                Row(
                  children: [
                    Text(
                      AppTexts.dmItemsCount(order.resolvedItemCount),
                      style: mutedStyle,
                    ),
                    if (order.resolvedTotal > 0) ...[
                      AppSpacing.horizontal(context, 0.02),
                      Text(
                        AppFormatter.currencyWhole(order.resolvedTotal),
                        style: mutedStyle.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Icon(
            AppIcons.chevronRight,
            color: AppColors.black,
            size: AppResponsive.scaleSize(context, 22),
          ),
        ],
      ),
    );
  }
}
