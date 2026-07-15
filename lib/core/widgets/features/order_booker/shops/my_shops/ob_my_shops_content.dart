import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/shops/my_shops/ob_my_shop_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_async_body.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_my_shops_controller.dart';

class ObMyShopsContent extends GetView<ObMyShopsController> {
  const ObMyShopsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppSpacing.screenPadding(context),
          child: AppSearchField(
            controller: controller.searchController,
            hint: AppTexts.obSearchShopHint,
            prefixIcon: AppIcons.search,
            suffixIcon: null,
          ),
        ),
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenPadding(
              context,
            ).copyWith(top: 0, bottom: 0),
            child: Row(
              children: [
                AppFilterChip(
                  label: AppTexts.obShopsFilterAll,
                  selected: controller.isFilterSelected(null),
                  onTap: () => controller.selectFilter(null),
                ),
                for (final status in controller.filterStatuses)
                  AppFilterChip.shopStatus(
                    status: status,
                    selected: controller.isFilterSelected(status),
                    onTap: () => controller.selectFilter(status),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final shops = controller.filteredShops;
            return AppAsyncBody(
              isLoading: controller.isLoading.value,
              hasError: controller.error.value != null,
              isEmpty: shops.isEmpty,
              errorMessage: controller.error.value,
              emptyTitle: AppTexts.emptyNoShopsTitle,
              emptySubtitle: AppTexts.obNoShopsFound,
              emptyImage: AppImages.emptyNoShops,
              onRefresh: () => controller.loadShops(force: true),
              child: ListView.builder(
                padding: AppSpacing.screenPadding(context),
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppSpacing.verticalValue(context, 0.01),
                    ),
                    child: ObMyShopCard(
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
