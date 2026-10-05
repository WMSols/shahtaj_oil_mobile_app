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
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/pickup/dm_pickup_summary_card.dart';

class DmPickupContent extends GetView<DmPickupController> {
  const DmPickupContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final load = controller.load.value;
      if (load == null) {
        return AppEmptyState(
          title: AppTexts.emptyLoadFailedTitle,
          subtitle: controller.error.value ?? AppTexts.emptyLoadFailedSubtitle,
          onRefresh: () => controller.loadToday(force: true),
        );
      }

      final remaining = controller.remainingPickLines;
      final hasAnyLines = load.pickLines.isNotEmpty;

      if (!hasAnyLines) {
        return ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            DmPickupSummaryCard(load: load),
            AppSpacing.vertical(context, 0.016),
            AppEmptyState(
              title: AppTexts.dmPickupDone,
              subtitle: AppTexts.dmLoadEmptySubtitle,
              image: AppImages.emptyNoPickup,
            ),
            if (controller.canDepart) ...[
              AppSpacing.vertical(context, 0.016),
              AppPrimaryButton(
                label: AppTexts.dmDepartTitle,
                isLoading: controller.isSubmitting.value,
                onPressed: controller.departToTodayPlan,
              ),
            ],
          ],
        );
      }

      return ListView(
        padding: AppSpacing.screenPadding(context),
        children: [
          DmPickupSummaryCard(load: load),
          AppSpacing.vertical(context, 0.016),
          if (remaining.isNotEmpty) ...[
            AppSectionHeader(
              title: AppTexts.dmPickupItems,
              bottomSpacing: true,
            ),
            for (final line in remaining)
              Padding(
                padding: EdgeInsets.only(
                  bottom: AppSpacing.verticalValue(context, 0.01),
                ),
                child: DmPickupItemCard(
                  key: ValueKey(line.productId),
                  line: line,
                  controller: controller,
                ),
              ),
            AppSpacing.vertical(context, 0.01),
            AppPrimaryButton(
              label: AppTexts.dmConfirmPickup,
              isLoading: controller.isSubmitting.value,
              onPressed: controller.confirmCollectivePick,
            ),
          ] else ...[
            AppEmptyState(
              title: AppTexts.dmPickupDone,
              subtitle: AppTexts.dmNextDepartSubtitle,
              image: AppImages.emptyNoPickup,
            ),
            if (controller.canDepart) ...[
              AppSpacing.vertical(context, 0.016),
              AppPrimaryButton(
                label: AppTexts.dmDepartTitle,
                isLoading: controller.isSubmitting.value,
                onPressed: controller.departToTodayPlan,
              ),
            ],
          ],
        ],
      );
    });
  }
}
