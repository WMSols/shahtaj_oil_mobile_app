import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/text/app_text.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recover_shop_item.dart';

class DmRecoverShopCard extends StatelessWidget {
  const DmRecoverShopCard({super.key, required this.shop, this.onTap});

  final DmRecoverShopItem shop;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.bodyText(context).copyWith(
      color: AppColors.grey,
      fontSize: AppResponsive.scaleSize(context, 13),
    );
    final stripeColor = shop.creditExceeded
        ? AppColors.warning
        : AppColors.primary;

    return AppOutlineCard(
      onTap: onTap,
      statusColor: stripeColor,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText.label(
                        shop.shopName,
                        style: AppTextStyles.sectionTitle(context),
                      ),
                    ),
                    if (shop.creditExceeded)
                      AppStatusChip(
                        label: AppTexts.dmHighDueChip,
                        color: AppColors.warning,
                        soft: true,
                      ),
                  ],
                ),
                if ((shop.orderName ?? '').isNotEmpty) ...[
                  AppSpacing.vertical(context, 0.004),
                  Text(shop.orderName!, style: muted),
                ],
                AppSpacing.vertical(context, 0.006),
                Text(
                  '${AppTexts.dmUnpaidInvoices}: ${shop.unpaidCount}'
                  ' · ${AppTexts.dmPaidInvoices}: ${shop.paidCount}',
                  style: muted,
                ),
                if (shop.detailsLoaded) ...[
                  AppSpacing.vertical(context, 0.008),
                  Text(
                    '${AppTexts.dmOutstandingLabel}: '
                    '${AppFormatter.currency(shop.outstanding, symbol: 'Rs. ')}',
                    style: AppTextStyles.sectionTitle(context).copyWith(
                      color: shop.creditExceeded
                          ? AppColors.warning
                          : (shop.outstanding > 0
                                ? AppColors.primary
                                : AppColors.success),
                    ),
                  ),
                ],
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
