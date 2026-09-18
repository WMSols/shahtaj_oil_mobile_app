import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/van_stock/dm_van_stock_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_item_view.dart';

class DmVanStockItemRow extends StatelessWidget {
  const DmVanStockItemRow({
    super.key,
    required this.item,
    required this.controller,
  });

  final DmVanItemView item;
  final DmVanStockController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final editing = controller.canEditQty;
      final error = controller.qtyErrors[item.id];
      final metricStyle = AppTextStyles.caption(
        context,
      ).copyWith(color: AppColors.grey);
      final statusColor = item.qtyOnVan > 0
          ? AppColors.success
          : AppColors.warning;

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
            if ((item.uom ?? '').isNotEmpty) ...[
              AppSpacing.vertical(context, 0.002),
              Text(item.uom!, style: metricStyle),
            ],
            AppSpacing.vertical(context, 0.004),
            Text(
              '${AppTexts.dmQtyOnVan}: ${AppFormatter.targetAmount(item.qtyOnVan)}',
              style: metricStyle,
            ),
            if (controller.mode.value == DmVanStockMode.loadFromWh)
              Text(
                '${AppTexts.dmQtyInWarehouse}: ${AppFormatter.targetAmount(item.qtyInWarehouse)}',
                style: metricStyle,
              ),
            if (editing) ...[
              AppSpacing.vertical(context, 0.01),
              AppTextField(
                controller: controller.qtyControllerFor(item.id),
                label: controller.mode.value == DmVanStockMode.loadFromWh
                    ? AppTexts.dmVanLoadQtyLabel
                    : AppTexts.dmVanUnloadQtyLabel,
                hint: controller.mode.value == DmVanStockMode.loadFromWh
                    ? AppTexts.dmLoadedQtyHint
                    : AppTexts.dmVanUnloadQtyHint,
                prefixIcon: AppIcons.myshops,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
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
