import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_async_body.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_recover_shop_card.dart';

class DmTodayShopsContent extends GetView<DmTodayShopsController> {
  const DmTodayShopsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppSpacing.screenPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.dmRecoverShopsSubtitle,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: AppColors.grey),
              ),
              AppSpacing.vertical(context, 0.012),
              AppSearchField(
                key: const ValueKey('dm_recover_shops_search'),
                hint: AppTexts.dmShopSearchHint,
                prefixIcon: AppIcons.search,
                suffixIcon: null,
                onChanged: controller.onSearchChanged,
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final rows = controller.visibleShops;
            final hasQuery = controller.query.value.trim().isNotEmpty;
            return AppAsyncBody(
              isLoading: controller.isLoading.value && controller.shops.isEmpty,
              hasError:
                  controller.error.value != null && controller.shops.isEmpty,
              isEmpty: rows.isEmpty,
              errorMessage: controller.error.value,
              emptyTitle: hasQuery
                  ? AppTexts.dmNoShopsMatchSearch
                  : AppTexts.emptyNoShopsTitle,
              emptySubtitle: hasQuery ? null : AppTexts.dmRecoverNoPlanShops,
              emptyImage: AppImages.emptyNoShops,
              onRefresh: () => controller.loadShops(force: true),
              loading: AppShimmerSkeletons.shopList(context),
              child: ListView.builder(
                padding: AppSpacing.screenPadding(context),
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  final shop = rows[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppSpacing.verticalValue(context, 0.01),
                    ),
                    child: DmRecoverShopCard(
                      shop: shop,
                      onTap: () => controller.openShop(shop),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
