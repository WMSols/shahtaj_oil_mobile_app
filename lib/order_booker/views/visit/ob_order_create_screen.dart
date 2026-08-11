import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/visit/ob_product_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/visit/ob_shop_credit_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/visit/ob_visit_cart_panel.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/visit/ob_visit_header_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/visit/ob_order_create_controller.dart';

class ObOrderCreateScreen extends GetView<ObOrderCreateController> {
  const ObOrderCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await controller.leave();
      },
      child: AppSubScreenScaffold(
        title: AppTexts.obOrderCreateTitle,
        body: Obx(() {
          if (controller.isLoading.value) {
            return AppShimmerSkeletons.genericList(context, count: 6);
          }
          if (controller.error.value != null) {
            return AppEmptyState(
              title: AppTexts.emptyLoadFailedTitle,
              subtitle: controller.error.value,
              image: AppImages.emptyError,
              actionLabel: controller.hasVisitMismatch.value
                  ? AppTexts.obResumeVisit
                  : null,
              onAction: controller.hasVisitMismatch.value
                  ? controller.resumeActiveVisit
                  : null,
              onRefresh: controller.load,
            );
          }

          final visit = controller.activeVisit.value;
          final cart = controller.cart.value;
          if (visit == null || cart == null) {
            return AppEmptyState(
              title: AppTexts.emptyNoActiveVisitTitle,
              subtitle: AppTexts.obActiveVisitMissing,
              image: AppImages.emptyNoVisit,
              onRefresh: controller.load,
            );
          }

          final products = controller.filteredProducts;
          return RefreshIndicator(
            onRefresh: controller.load,
            child: ListView(
              padding: AppSpacing.screenPadding(context),
              children: [
                ObVisitHeaderCard(
                  shopName: visit.shopName,
                  visitId: visit.visitId,
                ),
                if (controller.shop.value != null) ...[
                  AppSpacing.vertical(context, 0.016),
                  ObShopCreditCard(shop: controller.shop.value!),
                ],
                AppSpacing.vertical(context, 0.016),
                Text(AppTexts.obProductsSection),
                AppSpacing.vertical(context, 0.008),
                AppSearchField(
                  controller: controller.productSearchController,
                  hint: AppTexts.obSearchProductHint,
                  prefixIcon: AppIcons.search,
                  suffixIcon: null,
                ),
                AppSpacing.vertical(context, 0.008),
                if (products.isEmpty)
                  AppEmptyState(
                    title: AppTexts.emptyNoProductsTitle,
                    subtitle: AppTexts.obNoProductsFound,
                    image: AppImages.emptyNoProducts,
                  )
                else
                  ...products.map(
                    (product) => Padding(
                      padding: EdgeInsets.only(
                        bottom: AppSpacing.verticalValue(context, 0.01),
                      ),
                      child: ObProductCard(
                        product: product,
                        isInCart: controller.isProductInCart(product.id),
                        isAdding:
                            controller.addingProductId.value == product.id,
                        onAdd: () => controller.addProduct(product),
                      ),
                    ),
                  ),
                AppSpacing.vertical(context, 0.012),
                ObVisitCartPanel(controller: controller, cart: cart),
              ],
            ),
          );
        }),
      ),
    );
  }
}
