import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_async_body.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';

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
                hint: AppTexts.dmFreeDeliverSearchHint,
                prefixIcon: AppIcons.search,
                suffixIcon: null,
                onChanged: controller.onSearchChanged,
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isSearchMode) {
              final shops = controller.searchShops;
              return AppAsyncBody(
                isLoading: controller.isSearching.value && shops.isEmpty,
                hasError: false,
                isEmpty: !controller.isSearching.value && shops.isEmpty,
                emptyTitle: AppTexts.dmFreeDeliverEmpty,
                emptySubtitle: AppTexts.dmNoShopsMatchSearch,
                emptyImage: AppImages.emptyNoShops,
                onRefresh: controller.searchNow,
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
                      child: AppOutlineCard(
                        onTap: () => controller.openSearchShop(shop),
                        padding: AppSpacing.symmetric(
                          context,
                          h: 0.03,
                          v: 0.014,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shop.name,
                              style: AppTextStyles.sectionTitle(context),
                            ),
                            if ((shop.address ?? '').isNotEmpty)
                              Text(
                                shop.address!,
                                style: AppTextStyles.caption(
                                  context,
                                ).copyWith(color: AppColors.grey),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            final shops = controller.planShops;
            return AppAsyncBody(
              isLoading: controller.isLoading.value && shops.isEmpty,
              hasError: controller.error.value != null && shops.isEmpty,
              isEmpty: shops.isEmpty,
              errorMessage: controller.error.value,
              emptyTitle: AppTexts.emptyNoShopsTitle,
              emptySubtitle: AppTexts.dmRecoverNoPlanShops,
              emptyImage: AppImages.emptyNoShops,
              onRefresh: () => controller.loadShops(force: true),
              loading: AppShimmerSkeletons.shopList(context),
              child: ListView.builder(
                padding: AppSpacing.screenPadding(context),
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  final job = shops[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppSpacing.verticalValue(context, 0.01),
                    ),
                    child: AppOutlineCard(
                      onTap: () => controller.openPlanShop(job),
                      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.014),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.shopName,
                            style: AppTextStyles.sectionTitle(context),
                          ),
                          if ((job.shopAddress ?? '').isNotEmpty)
                            Text(
                              job.shopAddress!,
                              style: AppTextStyles.caption(
                                context,
                              ).copyWith(color: AppColors.grey),
                            ),
                          if ((job.orderName ?? '').isNotEmpty)
                            Text(
                              job.orderName!,
                              style: AppTextStyles.caption(
                                context,
                              ).copyWith(color: AppColors.grey),
                            ),
                        ],
                      ),
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
