import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/visit/ob_product_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/visit/ob_visit_cart_panel.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/visit/ob_visit_header_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_order_create_controller.dart';

class ObOrderCreateScreen extends GetView<ObOrderCreateController> {
  const ObOrderCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.obOrderCreateTitle,
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();
        if (controller.error.value != null) {
          return AppEmptyState(
            title: AppTexts.obOrderCreateTitle,
            subtitle: controller.error.value,
          );
        }

        final visit = controller.activeVisit.value;
        final cart = controller.cart.value;
        if (visit == null || cart == null) {
          return AppEmptyState(
            title: AppTexts.obOrderCreateTitle,
            subtitle: AppTexts.obActiveVisitMissing,
          );
        }

        final products = controller.products;
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            children: [
              ObVisitHeaderCard(
                shopName: visit.shopName,
                visitId: visit.visitId,
              ),
              AppSpacing.vertical(context, 0.016),
              Text(AppTexts.obProductsSection),
              AppSpacing.vertical(context, 0.008),
              if (products.isEmpty)
                AppEmptyState(
                  title: AppTexts.obNoProductsFound,
                  subtitle: AppTexts.obNoProductsFound,
                )
              else
                ...products.map(
                  (product) => Padding(
                    padding: EdgeInsets.only(
                      bottom: AppSpacing.verticalValue(context, 0.01),
                    ),
                    child: ObProductCard(
                      product: product,
                      onAdd: () => controller.addProduct(product),
                    ),
                  ),
                ),
              AppSpacing.vertical(context, 0.012),
              ObVisitCartPanel(
                cart: cart,
                onUpdateQuantity: controller.updateQuantity,
                maxQuantityForLine: controller.maxQuantityForLine,
                onRemoveLine: controller.removeLine,
                onPlaceOrder: controller.promptPlaceOrder,
                onEndWithoutOrder: controller.promptEndVisitWithoutOrder,
                onSaveNotes: controller.promptSaveVisitNotes,
                isPlacingOrder: controller.isPlacingOrder.value,
              ),
            ],
          ),
        );
      }),
    );
  }
}
