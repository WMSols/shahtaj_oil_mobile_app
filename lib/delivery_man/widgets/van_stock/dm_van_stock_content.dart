import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/van_stock/dm_van_stock_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/van_stock/dm_van_stock_item_row.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/van_stock/dm_van_stock_summary_card.dart';

class DmVanStockContent extends GetView<DmVanStockController> {
  const DmVanStockContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final snapshot = controller.snapshot.value;
      if (snapshot == null) {
        return AppEmptyState(
          title: AppTexts.emptyNotFoundTitle,
          subtitle: controller.error.value,
          onRefresh: () => controller.load(force: true),
        );
      }

      return ListView(
        padding: AppSpacing.screenPadding(context),
        children: [
          DmVanStockSummaryCard(snapshot: snapshot),
          AppSpacing.vertical(context, 0.012),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                AppFilterChip(
                  label: AppTexts.dmVanModeOnVan,
                  selected: controller.mode.value == DmVanStockMode.onVan,
                  onTap: () => controller.setMode(DmVanStockMode.onVan),
                  uppercase: false,
                ),
                AppFilterChip(
                  label: AppTexts.dmVanModeLoadFromWh,
                  selected: controller.mode.value == DmVanStockMode.loadFromWh,
                  onTap: () => controller.setMode(DmVanStockMode.loadFromWh),
                  uppercase: false,
                ),
                AppFilterChip(
                  label: AppTexts.dmVanModeReturnToWh,
                  selected: controller.mode.value == DmVanStockMode.returnToWh,
                  onTap: () => controller.setMode(DmVanStockMode.returnToWh),
                  uppercase: false,
                ),
              ],
            ),
          ),
          AppSpacing.vertical(context, 0.016),
          if (controller.rows.isEmpty)
            AppEmptyState(
              title: AppTexts.emptyNoStockTitle,
              subtitle: AppTexts.dmStockEmptySubtitle,
              image: AppImages.emptyNoStock,
              onRefresh: () => controller.load(force: true),
            )
          else ...[
            AppSectionHeader(
              title: AppTexts.dmVanStockItems,
              bottomSpacing: true,
            ),
            for (final item in controller.rows) ...[
              DmVanStockItemRow(item: item, controller: controller),
              AppSpacing.vertical(context, 0.01),
            ],
          ],
          if (controller.mode.value == DmVanStockMode.loadFromWh &&
              controller.rows.isNotEmpty) ...[
            AppPrimaryButton(
              label: AppTexts.dmVanConfirmLoad,
              isLoading: controller.isSubmitting.value,
              onPressed: controller.confirmLoad,
            ),
          ] else if (controller.mode.value == DmVanStockMode.returnToWh &&
              controller.rows.isNotEmpty) ...[
            AppPrimaryButton(
              label: AppTexts.dmVanConfirmUnload,
              isLoading: controller.isSubmitting.value,
              onPressed: controller.confirmReturn,
            ),
          ] else if (controller.mode.value == DmVanStockMode.onVan &&
              snapshot.qtyTotal > 0) ...[
            AppPrimaryButton(
              label: AppTexts.dmContinueDeliveries,
              onPressed: controller.goToOrders,
            ),
            AppSpacing.vertical(context, 0.01),
            AppSecondaryButton(
              label: AppTexts.dmVanModeReturnToWh,
              onPressed: () => controller.setMode(DmVanStockMode.returnToWh),
            ),
          ],
        ],
      );
    });
  }
}
