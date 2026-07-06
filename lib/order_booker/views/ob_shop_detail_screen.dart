import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/shops/shop_detail/ob_shop_detail_bottom_actions.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/shops/shop_detail/ob_shop_detail_hero.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/shops/shop_detail/ob_shop_detail_info_section.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/shops/shop_detail/ob_shop_detail_photos_section.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/shops/shop_detail/ob_shop_detail_summary_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shop_detail_controller.dart';

class ObShopDetailScreen extends GetView<ObShopDetailController> {
  const ObShopDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.obShopDetailTitle,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoader();
        }

        final shop = controller.shop.value;
        if (shop == null) {
          return AppEmptyState(title: AppTexts.obShopNotFound);
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ObShopDetailHero(
                      imageAsset:
                          shop.heroImageAsset ?? AppImages.onboardingIntro,
                    ),
                    Padding(
                      padding: AppSpacing.screenPadding(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ObShopDetailSummaryCard(
                            shop: shop,
                            onCallOwner: controller.callOwner,
                            onDirections: controller.openDirections,
                            onEditShop: controller.editShop,
                          ),
                          AppSpacing.vertical(context, 0.025),
                          ObShopDetailInfoSection(shop: shop),
                          AppSpacing.vertical(context, 0.025),
                          ObShopDetailPhotosSection(shop: shop),
                          AppSpacing.vertical(context, 0.02),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ObShopDetailBottomActions(
              onCreateOrder: controller.createOrder,
              onCheckIn: controller.checkInToShop,
            ),
          ],
        );
      }),
    );
  }
}
