import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_amount_summary_bar.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/visit/ob_cart_line_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/visit/ob_order_create_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_model.dart';

class ObVisitCartPanel extends StatelessWidget {
  const ObVisitCartPanel({
    super.key,
    required this.controller,
    required this.cart,
  });

  final ObOrderCreateController controller;
  final ObVisitCartModel cart;

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
              title: AppTexts.emptyCartTitle,
              subtitle: AppTexts.obAddProductsToStart,
              image: AppImages.emptyEmptyCart,
            )
          else ...[
            ...cart.lines.map((line) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: AppSpacing.verticalValue(context, 0.01),
                ),
                child: ObCartLineTile(controller: controller, line: line),
              );
            }),
          ],
          AppSpacing.vertical(context, 0.01),
          Obx(
            () => AppAmountSummaryBar(
              label: AppTexts.obSubtotal,
              amount: controller.displaySubtotal(),
            ),
          ),
          AppSpacing.vertical(context, 0.02),
          Obx(
            () => AppPrimaryButton(
              label: AppTexts.obPlaceOrder,
              isLoading: controller.isPlacingOrder.value,
              onPressed: hasLines ? controller.promptPlaceOrder : null,
            ),
          ),
          AppSpacing.vertical(context, 0.008),
          AppSecondaryButton(
            label: AppTexts.obEndVisitWithoutOrder,
            outlinedOnly: true,
            onPressed: controller.promptEndVisitWithoutOrder,
          ),
          AppSpacing.vertical(context, 0.008),
          AppSecondaryButton(
            label: AppTexts.obSaveVisitNotes,
            outlinedOnly: true,
            onPressed: controller.promptSaveVisitNotes,
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
