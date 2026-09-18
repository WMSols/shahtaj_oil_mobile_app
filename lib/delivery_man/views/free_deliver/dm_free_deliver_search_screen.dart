import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/free_deliver/dm_free_deliver_search_controller.dart';

class DmFreeDeliverSearchScreen extends GetView<DmFreeDeliverSearchController> {
  const DmFreeDeliverSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        final shops = controller.shops;
        return RefreshIndicator(
          onRefresh: controller.search,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
            children: [
              Text(
                AppTexts.dmFreeDeliverSubtitle,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: AppColors.grey),
              ),
              AppSpacing.vertical(context, 0.012),
              AppSearchField(
                hint: AppTexts.dmFreeDeliverSearchHint,
                onChanged: controller.onQueryChanged,
              ),
              AppSpacing.vertical(context, 0.016),
              if (controller.isLoading.value && shops.isEmpty)
                AppShimmerSkeletons.genericList(context)
              else if (controller.hasSearched.value && shops.isEmpty)
                Padding(
                  padding: EdgeInsets.only(
                    top: AppSpacing.verticalValue(context, 0.06),
                  ),
                  child: AppEmptyState(
                    title: AppTexts.dmFreeDeliverEmpty,
                    image: AppImages.empty,
                  ),
                )
              else
                ...shops.map(
                  (shop) => Padding(
                    padding: EdgeInsets.only(
                      bottom: AppSpacing.verticalValue(context, 0.012),
                    ),
                    child: AppOutlineCard(
                      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.014),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.openShop(shop),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shop.name,
                                        style: AppTextStyles.sectionTitle(
                                          context,
                                        ),
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
                                Icon(
                                  AppIcons.chevronRight,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.vertical(context, 0.01),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => controller.openRecover(shop),
                              child: Text(
                                AppTexts.dmRecoverAtShop,
                                style: AppTextStyles.caption(
                                  context,
                                ).copyWith(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
