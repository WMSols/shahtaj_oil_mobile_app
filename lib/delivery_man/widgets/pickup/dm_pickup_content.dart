import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/pickup/dm_pickup_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/pickup/dm_pickup_item_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/pickup/dm_pickup_shop_tile.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/pickup/dm_pickup_summary_card.dart';

class DmPickupContent extends GetView<DmPickupController> {
  const DmPickupContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final load = controller.load.value;
      if (load == null) {
        return AppEmptyState(
          title: AppTexts.emptyNotFoundTitle,
          subtitle: controller.error.value,
          onRefresh: () => controller.loadToday(force: true),
        );
      }

      if (load.pickLines.isEmpty && load.shops.isEmpty) {
        return ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            DmPickupSummaryCard(load: load),
            AppSpacing.vertical(context, 0.016),
            // Parent RefreshIndicator handles pull-to-refresh.
            AppEmptyState(
              title: AppTexts.emptyNotFoundTitle,
              subtitle: AppTexts.dmLoadEmptySubtitle,
              image: AppImages.emptyNoPickup,
            ),
          ],
        );
      }

      return ListView(
        padding: AppSpacing.screenPadding(context),
        children: [
          DmPickupSummaryCard(load: load),
          if (load.pickLines.isNotEmpty) ...[
            AppSpacing.vertical(context, 0.016),
            AppSectionHeader(
              title: AppTexts.dmPickupItems,
              bottomSpacing: true,
            ),
            ...load.pickLines.map(
              (line) => Padding(
                padding: EdgeInsets.only(
                  bottom: AppSpacing.verticalValue(context, 0.01),
                ),
                child: DmPickupItemCard(
                  key: ValueKey(line.productId),
                  line: line,
                  controller: controller,
                ),
              ),
            ),
            AppSpacing.vertical(context, 0.01),
            AppPrimaryButton(
              label: controller.hasRemainingToPick
                  ? AppTexts.dmConfirmPickup
                  : AppTexts.dmPickupDone,
              isLoading:
                  controller.isSubmitting.value &&
                  controller.submittingJobId.value == null,
              onPressed: controller.hasRemainingToPick
                  ? controller.confirmCollectivePick
                  : null,
            ),
          ],
          if (load.shops.isNotEmpty) ...[
            AppSpacing.vertical(context, 0.02),
            AppSectionHeader(
              title: AppTexts.dmLoadShopsSection,
              bottomSpacing: true,
            ),
            for (final shop in load.shops) ...[
              DmPickupShopTile(job: shop, controller: controller),
              AppSpacing.vertical(context, 0.01),
            ],
          ],
        ],
      );
    });
  }
}
