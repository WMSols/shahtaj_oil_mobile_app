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
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_shop_due_model.dart';

class RmShopDueCard extends StatelessWidget {
  const RmShopDueCard({
    super.key,
    required this.shop,
    this.isPartial = false,
    this.onTap,
  });

  final RmShopDueModel shop;
  final bool isPartial;
  final VoidCallback? onTap;

  Color get _stripeColor {
    if (shop.hasHighDue) return AppColors.warning;
    if (isPartial) return AppColors.information;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(context).copyWith(
      color: AppColors.grey,
      fontSize: AppResponsive.scaleSize(context, 13),
    );

    return AppOutlineCard(
      onTap: onTap,
      statusColor: _stripeColor,
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
                      child: Text(
                        shop.name,
                        style: AppTextStyles.sectionTitle(context),
                      ),
                    ),
                    if (shop.hasHighDue)
                      AppStatusChip(
                        label: AppTexts.rmHighDueChip,
                        color: AppColors.warning,
                      )
                    else if (isPartial)
                      AppStatusChip(
                        label: AppTexts.rmPartialChip,
                        color: AppColors.information,
                      ),
                  ],
                ),
                if (shop.ownerName.isNotEmpty) ...[
                  AppSpacing.vertical(context, 0.005),
                  Text(AppTexts.obShopOwner(shop.ownerName), style: mutedStyle),
                ],
                AppSpacing.vertical(context, 0.006),
                Text(
                  AppTexts.rmInvoicesCount(shop.invoiceCount),
                  style: mutedStyle,
                ),
                AppSpacing.vertical(context, 0.008),
                Text(
                  '${AppTexts.rmOutstandingLabel}: '
                  '${AppFormatter.currency(shop.outstanding, symbol: 'Rs. ')}',
                  style: AppTextStyles.sectionTitle(context).copyWith(
                    color: shop.hasHighDue
                        ? AppColors.warning
                        : AppColors.primary,
                  ),
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
