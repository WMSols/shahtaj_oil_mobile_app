import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/van_stock/dm_van_stock_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';

class DmVanStockItemRow extends StatelessWidget {
  const DmVanStockItemRow({
    super.key,
    required this.item,
    required this.controller,
  });

  final DmStockItemModel item;
  final DmVanStockController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final session = controller.session.value;
      final isLoaded = session?.isLoaded ?? false;
      final editing = controller.isEditingQty;
      final error = controller.qtyErrors[item.id];
      final metricStyle = AppTextStyles.caption(
        context,
      ).copyWith(color: AppColors.grey);

      final statusColor = !(session?.isLoaded ?? false)
          ? AppColors.warning
          : item.isLowStock
          ? AppColors.warning
          : AppColors.success;

      return AppOutlineCard(
        statusColor: statusColor,
        width: double.infinity,
        padding: AppSpacing.symmetric(context, h: 0.03, v: 0.012),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.sectionTitle(context),
            ),
            if (item.unit.isNotEmpty) ...[
              AppSpacing.vertical(context, 0.002),
              Text(item.unit, style: metricStyle),
            ],
            AppSpacing.vertical(context, 0.004),
            Text(
              AppTexts.dmVanExpectedCount(item.expected),
              style: metricStyle,
            ),
            if (isLoaded) ...[
              Text(
                AppTexts.dmStockLoadedLabel(item.quantity),
                style: metricStyle,
              ),
              Text(
                AppTexts.dmStockOnHandCount(item.onHand),
                style: metricStyle,
              ),
            ],
            if (isLoaded && item.isLowStock) ...[
              AppSpacing.vertical(context, 0.006),
              AppStatusChip.lowStock(),
            ],
            if (editing) ...[
              AppSpacing.vertical(context, 0.01),
              AppTextField(
                controller: controller.qtyControllerFor(item.id),
                label: controller.canLoad
                    ? AppTexts.dmVanLoadQtyLabel
                    : AppTexts.dmVanUnloadQtyLabel,
                hint: controller.canLoad
                    ? AppTexts.dmLoadedQtyHint
                    : AppTexts.dmVanUnloadQtyHint,
                prefixIcon: AppIcons.myshops,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.done,
                onChanged: (raw) => controller.onQtyChanged(item.id, raw),
                errorText: error,
              ),
            ],
          ],
        ),
      );
    });
  }
}
