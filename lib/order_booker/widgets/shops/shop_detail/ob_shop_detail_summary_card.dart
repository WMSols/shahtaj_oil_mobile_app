import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_shop_summary_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_model.dart';

class ObShopDetailSummaryCard extends StatelessWidget {
  const ObShopDetailSummaryCard({
    super.key,
    required this.shop,
    required this.onCallOwner,
    required this.onDirections,
  });

  final ObShopModel shop;
  final VoidCallback? onCallOwner;
  final VoidCallback? onDirections;

  @override
  Widget build(BuildContext context) {
    return AppShopSummaryCard(
      name: shop.name,
      ownerName: shop.ownerName,
      phone: shop.phone,
      statusColor: shop.status.chipColor,
      trailing: AppStatusChip.shop(shop.status),
      callLabel: AppTexts.obCallOwner,
      directionsLabel: AppTexts.obDirections,
      onCall: onCallOwner,
      onDirections: onDirections,
    );
  }
}
