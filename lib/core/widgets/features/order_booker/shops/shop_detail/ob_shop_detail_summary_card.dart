import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_outline_icon_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';

class ObShopDetailSummaryCard extends StatelessWidget {
  const ObShopDetailSummaryCard({
    super.key,
    required this.shop,
    required this.onCallOwner,
    required this.onDirections,
    required this.onEditShop,
  });

  final ObShopModel shop;
  final VoidCallback? onCallOwner;
  final VoidCallback? onDirections;
  final VoidCallback? onEditShop;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(context);

    return AppOutlineCard(
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.018),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  shop.name,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              AppSpacing.horizontal(context, 0.02),
              AppStatusChip.shop(shop.status),
            ],
          ),
          if (shop.ownerName != null || shop.phone != null) ...[
            AppSpacing.vertical(context, 0.01),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.horizontalValue(context, 0.02),
              runSpacing: AppSpacing.verticalValue(context, 0.004),
              children: [
                if (shop.ownerName != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppIcons.person5,
                        size: AppResponsive.iconSize(context, factor: 0.8),
                        color: AppColors.primary,
                      ),
                      AppSpacing.horizontal(context, 0.008),
                      Text(shop.ownerName!, style: mutedStyle),
                    ],
                  ),
                if (shop.ownerName != null && shop.phone != null)
                  Text('•', style: mutedStyle),
                if (shop.phone != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppIcons.phone5,
                        size: AppResponsive.iconSize(context, factor: 0.8),
                        color: AppColors.primary,
                      ),
                      AppSpacing.horizontal(context, 0.008),
                      Text(shop.phone!, style: mutedStyle),
                    ],
                  ),
              ],
            ),
          ],
          AppSpacing.vertical(context, 0.016),
          Row(
            children: [
              AppOutlineIconButton(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                icon: AppIcons.phone5,
                label: AppTexts.obCallOwner,
                onTap: onCallOwner,
              ),
              AppSpacing.horizontal(context, 0.015),
              AppOutlineIconButton(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                icon: AppIcons.routes5,
                label: AppTexts.obDirections,
                onTap: onDirections,
              ),
              AppSpacing.horizontal(context, 0.015),
              AppOutlineIconButton(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                icon: AppIcons.edit,
                label: AppTexts.obEditShop,
                onTap: onEditShop,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
