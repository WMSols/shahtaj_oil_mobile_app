import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_product_model.dart';

class ObProductCard extends StatelessWidget {
  const ObProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    this.isInCart = false,
  });

  final ObProductModel product;
  final VoidCallback onAdd;
  final bool isInCart;

  @override
  Widget build(BuildContext context) {
    final outOfStock = product.qtyBookable <= 0;
    return AppOutlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              Text(
                AppFormatter.currencyWhole(product.priceUnit),
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (product.sku != null && product.sku!.trim().isNotEmpty) ...[
            AppSpacing.vertical(context, 0.004),
            Text(product.sku!, style: AppTextStyles.caption(context)),
          ],
          AppSpacing.vertical(context, 0.005),
          Text(
            AppTexts.obQtyBookable(
              product.qtyBookable.toStringAsFixed(1),
              product.unit,
            ),
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(color: outOfStock ? AppColors.warning : AppColors.grey),
          ),
          if (!isInCart) ...[
            AppSpacing.vertical(context, 0.01),
            AppPrimaryButton(
              label: AppTexts.obAddToCart,
              icon: AppIcons.add,
              onPressed: outOfStock ? null : onAdd,
            ),
          ],
        ],
      ),
    );
  }
}
