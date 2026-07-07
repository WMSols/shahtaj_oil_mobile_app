import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_icon_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';

class ObCartLineTile extends StatelessWidget {
  const ObCartLineTile({
    super.key,
    required this.line,
    required this.maxQuantity,
    required this.onUpdateQuantity,
    required this.onRemove,
  });

  final ObVisitCartLineModel line;
  final int maxQuantity;
  final ValueChanged<double> onUpdateQuantity;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final currentQty = line.quantity.round().clamp(1, maxQuantity);
    final isLimitReached = currentQty >= maxQuantity;

    return AppOutlineCard(
      color: AppColors.grey.withValues(alpha: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  line.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyText(
                    context,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              AppIconButton(
                icon: AppIcons.delete,
                onTap: onRemove,
                backgroundColor: AppColors.error,
                iconColor: AppColors.white,
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.006),
          Text(
            AppTexts.obQtyBookable(maxQuantity.toString(), line.unit ?? ''),
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: AppColors.grey),
          ),
          AppSpacing.vertical(context, 0.01),
          _LabeledValue(
            label: AppTexts.obCartPriceHint,
            child: Text(
              AppFormatter.currencyWhole(line.priceUnit),
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          AppSpacing.vertical(context, 0.01),
          _LabeledValue(
            label: AppTexts.obCartQuantityHint,
            child: _QtyAdjuster(
              quantity: currentQty,
              maxQuantity: maxQuantity,
              onChanged: (value) => onUpdateQuantity(value.toDouble()),
            ),
          ),
          if (isLimitReached) ...[
            AppSpacing.vertical(context, 0.006),
            Text(
              AppTexts.obNoMoreStockLeft,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.warning, fontWeight: FontWeight.w600),
            ),
          ],
          AppSpacing.vertical(context, 0.01),
          _LabeledValue(
            label: AppTexts.obTotalLabel,
            child: Text(
              AppFormatter.currencyWhole(line.lineTotal),
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: AppColors.black, fontWeight: FontWeight.w600),
          ),
        ),
        AppSpacing.horizontal(context, 0.004),
        child,
      ],
    );
  }
}

class _QtyAdjuster extends StatelessWidget {
  const _QtyAdjuster({
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
  });

  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          icon: AppIcons.arrowDown,
          onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
          backgroundColor: AppColors.primary,
          iconColor: AppColors.white,
        ),
        AppSpacing.horizontal(context, 0.02),
        Text(
          '$quantity  /  $maxQuantity',
          style: AppTextStyles.caption(
            context,
          ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
        ),
        AppSpacing.horizontal(context, 0.02),
        AppIconButton(
          icon: AppIcons.arrowUp,
          onTap: quantity < maxQuantity ? () => onChanged(quantity + 1) : null,
          backgroundColor: AppColors.primary,
          iconColor: AppColors.white,
        ),
      ],
    );
  }
}
