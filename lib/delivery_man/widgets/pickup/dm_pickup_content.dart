import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/pickup/dm_pickup_item_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/pickup/dm_pickup_summary_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/pickup/dm_pickup_controller.dart';

class DmPickupContent extends GetView<DmPickupController> {
  const DmPickupContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pickup = controller.pickup.value;
      if (pickup == null) return const SizedBox.shrink();

      return ListView(
        padding: AppSpacing.screenPadding(context),
        children: [
          DmPickupSummaryCard(pickup: pickup),
          AppSpacing.vertical(context, 0.016),
          AppSectionHeader(title: AppTexts.dmPickupItems, bottomSpacing: true),
          ...pickup.items.map(
            (item) => Padding(
              padding: EdgeInsets.only(
                bottom: AppSpacing.verticalValue(context, 0.01),
              ),
              child: DmPickupItemCard(
                key: ValueKey(item.id),
                item: item,
                controller: controller,
              ),
            ),
          ),
          AppSpacing.vertical(context, 0.01),
          AppPrimaryButton(
            label: pickup.isAcknowledged
                ? AppTexts.dmPickupDone
                : AppTexts.dmConfirmPickup,
            isLoading: controller.isSubmitting.value,
            onPressed: pickup.isAcknowledged ? null : controller.confirmPickup,
          ),
        ],
      );
    });
  }
}
