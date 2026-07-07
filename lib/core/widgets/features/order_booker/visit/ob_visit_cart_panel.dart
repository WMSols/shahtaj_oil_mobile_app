import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/visit/ob_cart_line_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';

class ObVisitCartPanel extends StatelessWidget {
  const ObVisitCartPanel({
    super.key,
    required this.cart,
    required this.onUpdateQuantity,
    required this.onRemoveLine,
    required this.onPlaceOrder,
    required this.onEndWithoutOrder,
    required this.onSaveNotes,
    required this.maxQuantityForLine,
    this.isPlacingOrder = false,
  });

  final ObVisitCartModel cart;
  final void Function(int lineId, double quantity) onUpdateQuantity;
  final void Function(int lineId) onRemoveLine;
  final VoidCallback onPlaceOrder;
  final VoidCallback onEndWithoutOrder;
  final VoidCallback onSaveNotes;
  final int Function(ObVisitCartLineModel line) maxQuantityForLine;
  final bool isPlacingOrder;

  @override
  Widget build(BuildContext context) {
    final hasLines = cart.lines.isNotEmpty;
    return AppOutlineCard(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppTexts.obCartSection,
                  style: AppTextStyles.sectionTitle(
                    context,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _SummaryPill(label: '${cart.lineCount}'),
            ],
          ),
          AppSpacing.vertical(context, 0.01),
          if (!hasLines)
            AppEmptyState(
              title: AppTexts.obNoCartItems,
              subtitle: AppTexts.obAddProductsToStart,
            )
          else ...[
            ...cart.lines.map((line) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: AppSpacing.verticalValue(context, 0.01),
                ),
                child: ObCartLineTile(
                  line: line,
                  maxQuantity: maxQuantityForLine(line),
                  onUpdateQuantity: (qty) => onUpdateQuantity(line.lineId, qty),
                  onRemove: () => onRemoveLine(line.lineId),
                ),
              );
            }),
          ],
          AppSpacing.vertical(context, 0.01),
          Container(
            padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context),
              ),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppTexts.obSubtotal,
                    style: AppTextStyles.caption(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  AppFormatter.currencyWhole(cart.subtotal),
                  style: AppTextStyles.bodyText(context).copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.vertical(context, 0.02),
          AppPrimaryButton(
            label: AppTexts.obPlaceOrder,
            isLoading: isPlacingOrder,
            onPressed: hasLines ? onPlaceOrder : null,
          ),
          AppSpacing.vertical(context, 0.008),
          AppSecondaryButton(
            label: AppTexts.obEndVisitWithoutOrder,
            outlinedOnly: true,
            onPressed: onEndWithoutOrder,
          ),
          AppSpacing.vertical(context, 0.008),
          AppSecondaryButton(
            label: AppTexts.obSaveVisitNotes,
            outlinedOnly: true,
            onPressed: onSaveNotes,
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.004),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption(
          context,
        ).copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
      ),
    );
  }
}
