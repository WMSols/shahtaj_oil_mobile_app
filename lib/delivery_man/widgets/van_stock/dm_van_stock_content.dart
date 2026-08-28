import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/van_stock/dm_van_stock_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/van_stock/dm_van_stock_history_section.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/van_stock/dm_van_stock_item_row.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/van_stock/dm_van_stock_summary_card.dart';

class DmVanStockContent extends GetView<DmVanStockController> {
  const DmVanStockContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final session = controller.session.value;
      if (session == null) {
        return AppEmptyState(title: AppTexts.emptyNotFoundTitle);
      }

      if (session.items.isEmpty) {
        return ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            DmVanStockSummaryCard(session: session),
            AppSpacing.vertical(context, 0.016),
            AppEmptyState(
              title: AppTexts.emptyNoStockTitle,
              subtitle: AppTexts.dmStockEmptySubtitle,
              image: AppImages.emptyNoStock,
            ),
            AppSpacing.vertical(context, 0.016),
            DmVanStockHistorySection(history: session.history),
          ],
        );
      }

      return ListView(
        padding: AppSpacing.screenPadding(context),
        children: [
          DmVanStockSummaryCard(session: session),
          AppSpacing.vertical(context, 0.016),
          AppSectionHeader(
            title: AppTexts.dmVanStockItems,
            bottomSpacing: true,
          ),
          for (final item in session.items) ...[
            DmVanStockItemRow(item: item, controller: controller),
            AppSpacing.vertical(context, 0.01),
          ],
          if (controller.isEditingQty) ...[
            AppTextField(
              hint: AppTexts.dmVanNotesHint,
              initialValue: controller.notes.value,
              minLines: 2,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              onChanged: controller.onNotesChanged,
            ),
            AppSpacing.vertical(context, 0.014),
          ],
          if (controller.canLoad) ...[
            AppPrimaryButton(
              label: AppTexts.dmVanConfirmLoad,
              isLoading: controller.isSubmitting.value,
              onPressed: controller.confirmLoad,
            ),
          ] else if (session.isUnloaded) ...[
            AppPrimaryButton(label: AppTexts.dmVanUnloadDone, onPressed: null),
          ] else if (session.isLoaded) ...[
            if (session.totalOnHand <= 0)
              AppPrimaryButton(
                label: AppTexts.dmVanCloseEmpty,
                isLoading: controller.isSubmitting.value,
                onPressed: controller.confirmUnload,
              )
            else ...[
              AppPrimaryButton(
                label: AppTexts.dmContinueDeliveries,
                onPressed: controller.goToOrders,
              ),
              AppSpacing.vertical(context, 0.01),
              AppSecondaryButton(
                label: AppTexts.dmVanConfirmUnload,
                isLoading: controller.isSubmitting.value,
                onPressed: controller.confirmUnload,
              ),
            ],
          ],
          AppSpacing.vertical(context, 0.02),
          DmVanStockHistorySection(history: session.history),
        ],
      );
    });
  }
}
