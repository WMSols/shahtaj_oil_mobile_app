import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';

class ObShopDetailInfoSection extends StatelessWidget {
  const ObShopDetailInfoSection({super.key, required this.shop});

  final ObShopModel shop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.obShopDetailsSection,
          style: AppTextStyles.sectionTitle(context),
        ),
        AppSpacing.vertical(context, 0.01),
        AppOutlineCard(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AppDetailRow(label: AppTexts.obShopNameLabel, value: shop.name),
              if (shop.ownerName != null)
                AppDetailRow(
                  label: AppTexts.obOwnerNameLabel,
                  value: shop.ownerName!,
                ),
              if (shop.phone != null)
                AppDetailRow(
                  label: AppTexts.obPhoneNumberLabel,
                  value: shop.phone!,
                ),
              if (shop.zoneName != null)
                AppDetailRow(
                  label: AppTexts.obZoneLabel,
                  value: shop.zoneName!,
                ),
              if (shop.routeName != null)
                AppDetailRow(
                  label: AppTexts.obRouteLabel,
                  value: shop.routeName!,
                ),
              AppDetailRow(
                label: AppTexts.obShopTypeLabel,
                trailing: AppStatusChip.shopType(shop.shopType),
              ),
              if (shop.isCreditShop && shop.creditLimit != null)
                AppDetailRow(
                  label: AppTexts.obCreditLimitLabel.replaceAll(' (Rs)', ''),
                  value: AppFormatter.currencyWhole(shop.creditLimit!),
                  valueColor: AppColors.primary,
                  valueWeight: FontWeight.w700,
                ),
              if (shop.isCreditShop && shop.outstandingBalance != null)
                AppDetailRow(
                  label: AppTexts.obOutstandingBalanceLabel,
                  value: AppFormatter.currencyWhole(shop.outstandingBalance!),
                  valueColor: AppColors.error,
                  valueWeight: FontWeight.w700,
                ),
              if (shop.isCreditShop && shop.resolvedCreditRemaining != null)
                AppDetailRow(
                  label: AppTexts.obCreditRemainingLabel,
                  value: AppFormatter.currencyWhole(
                    shop.resolvedCreditRemaining!,
                  ),
                  valueColor: shop.resolvedCreditRemaining! < 0
                      ? AppColors.error
                      : AppColors.success,
                  valueWeight: FontWeight.w700,
                ),
              if (shop.legacyBalance != null)
                AppDetailRow(
                  label: AppTexts.obLegacyBalanceLabel.replaceAll(' (Rs)', ''),
                  value: AppFormatter.currencyWhole(shop.legacyBalance!),
                  valueColor: AppColors.error,
                  valueWeight: FontWeight.w700,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
