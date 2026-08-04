import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/pickup/dm_pickup_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';

class DmPickupItemCard extends StatelessWidget {
  const DmPickupItemCard({super.key, required this.item});

  final DmStockItemModel item;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DmPickupController>();

    return Obx(() {
      final readOnly = controller.acknowledged.value;
      final error = controller.qtyErrors[item.id];

      return AppOutlineCard(
        statusColor: controller.stripeColorFor(item),
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
                        item.name,
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      if (item.unit.isNotEmpty)
                        Text(item.unit, style: AppTextStyles.caption(context)),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.vertical(context, 0.01),
            AppTextField(
              controller: controller.qtyControllerFor(item.id),
              label: AppTexts.dmLoadedQty,
              hint: AppTexts.dmLoadedQtyHint,
              prefixIcon: AppIcons.myshops,
              readOnly: readOnly,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              onChanged: readOnly
                  ? null
                  : (raw) => controller.onLoadedQtyChanged(item.id, raw),
              errorText: error,
            ),
          ],
        ),
      );
    });
  }
}
