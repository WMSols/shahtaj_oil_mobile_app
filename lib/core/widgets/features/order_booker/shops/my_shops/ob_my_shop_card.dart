import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';

class ObMyShopCard extends StatelessWidget {
  const ObMyShopCard({super.key, required this.shop, this.onTap});

  final ObShopModel shop;
  final VoidCallback? onTap;

  IconData get _locationIcon => shop.status == ShopStatus.rejected
      ? AppIcons.block5
      : shop.locationLabel?.toLowerCase().contains('route') == true
      ? AppIcons.routes5
      : AppIcons.location5;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(context).copyWith(
      color: AppColors.black,
      fontSize: AppResponsive.scaleSize(context, 13),
    );

    return AppOutlineCard(
      onTap: onTap,
      statusColor: shop.status.chipColor,
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
                      child: Text(
                        shop.name,
                        style: AppTextStyles.sectionTitle(context).copyWith(),
                      ),
                    ),
                    AppStatusChip.shop(shop.status),
                  ],
                ),
                if (shop.ownerName != null) ...[
                  AppSpacing.vertical(context, 0.005),
                  Text(
                    AppTexts.obShopOwner(shop.ownerName!),
                    style: mutedStyle,
                  ),
                ],
                AppSpacing.vertical(context, 0.005),
                Row(
                  children: [
                    if (shop.phone != null) ...[
                      Icon(
                        AppIcons.phone5,
                        size: AppResponsive.iconSize(context, factor: 0.8),
                        color: AppColors.primary,
                      ),
                      AppSpacing.horizontal(context, 0.01),
                      Flexible(
                        child: Text(
                          shop.phone!,
                          style: mutedStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    if (shop.phone != null && shop.locationLabel != null)
                      AppSpacing.horizontal(context, 0.02),
                    if (shop.locationLabel != null) ...[
                      Icon(
                        _locationIcon,
                        size: AppResponsive.iconSize(context, factor: 0.8),
                        color: AppColors.primary,
                      ),
                      AppSpacing.horizontal(context, 0.01),
                      Flexible(
                        child: Text(
                          shop.locationLabel!,
                          style: mutedStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.black,
            size: AppResponsive.scaleSize(context, 22),
          ),
        ],
      ),
    );
  }
}
