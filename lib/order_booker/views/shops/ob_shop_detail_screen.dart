import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/shops/shop_detail/ob_shop_detail_bottom_actions.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/shops/shop_detail/ob_shop_detail_hero.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/shops/shop_detail/ob_shop_detail_info_section.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/shops/shop_detail/ob_shop_detail_photos_section.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/shops/shop_detail/ob_shop_detail_summary_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_map_preview.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/shops/ob_shop_detail_controller.dart';

class ObShopDetailScreen extends GetView<ObShopDetailController> {
  const ObShopDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.obShopDetailTitle,
      body: Obx(() {
        if (controller.isLoading.value) {
          return AppShimmerSkeletons.detail(context);
        }

        final shop = controller.shop.value;
        if (shop == null) {
          return AppEmptyState(
            title: AppTexts.emptyNotFoundTitle,
            subtitle: AppTexts.obShopNotFound,
            image: AppImages.emptyNotFound,
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ObShopDetailHero(
                      imageAsset: shop.verificationPhotos.shopExterior,
                      isLoading: controller.isLoadingPhotos.value,
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
                          ),
                          if (controller.needsFirstVisitSetup) ...[
                            AppSpacing.vertical(context, 0.012),
                            Container(
                              width: double.infinity,
                              padding: AppSpacing.symmetric(
                                context,
                                h: 0.03,
                                v: 0.012,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.warning.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                              ),
                              child: Text(
                                AppTexts.obShopSetupRequiredBanner,
                                style: AppTextStyles.bodyText(context).copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          AppSpacing.vertical(context, 0.025),
                          ObShopDetailInfoSection(shop: shop),
                          if (shop.hasCoordinates) ...[
                            AppSpacing.vertical(context, 0.025),
                            Text(
                              AppTexts.obShopMapSection,
                              style: AppTextStyles.sectionTitle(context),
                            ),
                            AppSpacing.vertical(context, 0.01),
                            AppMapPreview(
                              latitude: shop.latitude,
                              longitude: shop.longitude,
                            ),
                          ],
                          if (controller.hasVerificationPhotos ||
                              controller.isLoadingPhotos.value) ...[
                            AppSpacing.vertical(context, 0.025),
                            ObShopDetailPhotosSection(
                              shop: shop,
                              isLoading: controller.isLoadingPhotos.value,
                            ),
                          ],
                          AppSpacing.vertical(context, 0.02),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => ObShopDetailBottomActions(
                showCreateOrder: controller.showResumeOrder,
                showCheckIn: controller.showCheckIn,
                createOrderLabel: controller.createOrderLabel,
                isCheckingIn: controller.isCheckingIn.value,
                onCreateOrder: controller.createOrder,
                onCheckIn: controller.checkInToShop,
              ),
            ),
          ],
        );
      }),
    );
  }
}
