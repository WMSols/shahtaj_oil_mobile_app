import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';

class ObShopDetailBottomActions extends StatelessWidget {
  const ObShopDetailBottomActions({
    super.key,
    required this.onCreateOrder,
    required this.onCheckIn,
  });

  final VoidCallback onCreateOrder;
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding(context).copyWith(top: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppPrimaryButton(
              label: AppTexts.obCreateOrderButton,
              icon: AppIcons.myshops5,
              onPressed: onCreateOrder,
            ),
            AppSpacing.vertical(context, 0.01),
            AppSecondaryButton(
              label: AppTexts.obCheckInToShop,
              icon: AppIcons.location5,
              outlinedOnly: true,
              onPressed: onCheckIn,
            ),
          ],
        ),
      ),
    );
  }
}
