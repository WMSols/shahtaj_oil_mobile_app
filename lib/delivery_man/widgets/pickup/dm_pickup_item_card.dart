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
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/pickup/dm_pickup_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/load/dm_pick_line_model.dart';

class DmPickupItemCard extends StatelessWidget {
  const DmPickupItemCard({
    super.key,
    required this.line,
    required this.controller,
  });

  final DmPickLineModel line;
  final DmPickupController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final key = '${line.productId}';
      final error = controller.qtyErrors[key];
      final readOnly = line.qtyToPick <= 0;
      final metricStyle = AppTextStyles.caption(
        context,
      ).copyWith(color: AppColors.grey);

      return AppOutlineCard(
        statusColor: controller.stripeColorFor(line),
        padding: AppSpacing.symmetric(context, h: 0.03, v: 0.012),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(AppIcons.orders, color: AppColors.primary),
                AppSpacing.horizontal(context, 0.012),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line.name,
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      if ((line.uom ?? '').isNotEmpty)
                        Text(line.uom!, style: metricStyle),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.vertical(context, 0.006),
            Text(
              '${AppTexts.dmQtyToPick}: ${AppFormatter.targetAmount(line.qtyToPick)}',
              style: metricStyle,
            ),
            Text(
              '${AppTexts.dmQtyOnVan}: ${AppFormatter.targetAmount(line.qtyOnVan)} · ${AppTexts.dmQtyInWarehouse}: ${AppFormatter.targetAmount(line.qtyInWarehouse)}',
              style: metricStyle,
            ),
            AppSpacing.vertical(context, 0.01),
            AppTextField(
              controller: controller.qtyControllerFor(line),
              label: AppTexts.dmLoadedQty,
              hint: AppTexts.dmLoadedQtyHint,
              prefixIcon: AppIcons.myshops,
              readOnly: readOnly,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              textInputAction: TextInputAction.done,
              onChanged: readOnly
                  ? null
                  : (raw) => controller.onQtyChanged(line, raw),
              errorText: error,
            ),
          ],
        ),
      );
    });
  }
}
