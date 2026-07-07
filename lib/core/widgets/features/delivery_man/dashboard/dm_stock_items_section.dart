import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dm_stock_item_model.dart';

class DmStockItemsSection extends StatelessWidget {
  const DmStockItemsSection({
    super.key,
    required this.items,
    required this.vanStockCount,
  });

  final List<DmStockItemModel> items;
  final int vanStockCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: AppSpacing.symmetric(context, h: 0.02, v: 0.005),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                AppIcons.deliveries,
                color: AppColors.white,
                size: AppResponsive.iconSize(context),
              ),
              AppSpacing.horizontal(context, 0.01),
              Text(
                AppTexts.dmVanStockSummary(vanStockCount),
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
        AppSpacing.vertical(context, 0.014),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.horizontalValue(context, 0.02),
            mainAxisSpacing: AppSpacing.verticalValue(context, 0.012),
            mainAxisExtent: AppSpacing.verticalValue(context, 0.35),
          ),
          itemBuilder: (context, index) => DmStockItemCard(item: items[index]),
        ),
      ],
    );
  }
}

class DmStockItemCard extends StatelessWidget {
  const DmStockItemCard({super.key, required this.item});

  final DmStockItemModel item;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.012),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.name}\n${item.unit}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle(context),
          ),
          Row(
            children: [
              Text(
                '${item.quantity}',
                style: AppTextStyles.heading(
                  context,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              if (item.isLowStock) AppStatusChip.lowStock(),
            ],
          ),
          AppSpacing.vertical(context, 0.01),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: item.imageAsset == null
                  ? Icon(
                      AppIcons.image,
                      color: AppColors.textMuted,
                      size: AppResponsive.iconSize(context, factor: 1.5),
                    )
                  : Image.asset(item.imageAsset!, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
