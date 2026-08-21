import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_async_body.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_shop_due_card.dart';

class DmTodayShopsContent extends GetView<DmTodayShopsController> {
  const DmTodayShopsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppSpacing.screenPadding(context),
          child: AppSearchField(
            key: const ValueKey('dm_today_shops_search'),
            hint: AppTexts.dmSearchShopHint,
            prefixIcon: AppIcons.search,
            suffixIcon: null,
            onChanged: controller.onSearchChanged,
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
                  selected: controller.isFilterSelected(DmShopDueFilter.all),
                  onTap: () => controller.selectFilter(DmShopDueFilter.all),
                ),
                AppFilterChip(
                  label: AppTexts.dmFilterHighDue,
                  selected: controller.isFilterSelected(
                    DmShopDueFilter.highDue,
                  ),
                  onTap: () => controller.selectFilter(DmShopDueFilter.highDue),
                ),
                AppFilterChip(
                  label: AppTexts.dmFilterPartial,
                  selected: controller.isFilterSelected(
                    DmShopDueFilter.partial,
                  ),
                  onTap: () => controller.selectFilter(DmShopDueFilter.partial),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final shops = controller.filteredShops;
            final hasQuery = controller.searchQuery.value.trim().isNotEmpty;
            final isFiltered =
                controller.dueFilter.value != null &&
                controller.dueFilter.value != DmShopDueFilter.all;

            return AppAsyncBody(
              isLoading:
                  controller.isLoading.value && !controller.hasCachedData,
              hasError: controller.error.value != null && shops.isEmpty,
              isEmpty: shops.isEmpty,
              errorMessage: controller.error.value,
              emptyTitle: AppTexts.emptyNoShopsTitle,
              emptySubtitle: hasQuery || isFiltered
                  ? AppTexts.dmNoShopsMatchSearch
                  : AppTexts.dmNoShopsDue,
              emptyImage: AppImages.emptyNoShops,
              onRefresh: () => controller.loadShops(force: true),
              loading: AppShimmerSkeletons.shopList(context),
              child: ListView.builder(
                padding: AppSpacing.screenPadding(context),
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppSpacing.verticalValue(context, 0.01),
                    ),
                    child: DmShopDueCard(
                      shop: shop,
                      isPartial: controller.shopIsPartial(shop),
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
