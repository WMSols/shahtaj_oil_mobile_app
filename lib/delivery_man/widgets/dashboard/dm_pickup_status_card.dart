import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';

class DmPickupStatusCard extends StatelessWidget {
  const DmPickupStatusCard({
    super.key,
    required this.pickupConfirmed,
    required this.onGoToPickup,
    required this.onContinueDeliveries,
  });

  final bool pickupConfirmed;
  final VoidCallback onGoToPickup;
  final VoidCallback onContinueDeliveries;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      statusColor: pickupConfirmed ? AppColors.success : AppColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                AppIcons.deliver,
                color: pickupConfirmed ? AppColors.success : AppColors.warning,
              ),
              AppSpacing.horizontal(context, 0.01),
              Expanded(
                child: Text(
                  pickupConfirmed
                      ? AppTexts.dmPickupDone
                      : AppTexts.dmPickupRequired,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.01),
          if (!pickupConfirmed)
            AppPrimaryButton(
              label: AppTexts.dmGoToPickup,
              onPressed: onGoToPickup,
            )
          else
            AppSecondaryButton(
              outlinedOnly: true,
              label: AppTexts.dmContinueDeliveries,
              onPressed: onContinueDeliveries,
            ),
        ],
      ),
    );
  }
}
