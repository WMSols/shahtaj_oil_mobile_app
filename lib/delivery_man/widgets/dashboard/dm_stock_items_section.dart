import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';

class DmStockItemsSection extends StatelessWidget {
  const DmStockItemsSection({
    super.key,
    required this.items,
    this.previewLimit = 4,
  });

  final List<DmStockItemModel> items;
  final int previewLimit;

  @override
  Widget build(BuildContext context) {
    final preview = items.take(previewLimit).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < preview.length; index++) ...[
          if (index > 0) AppSpacing.vertical(context, 0.008),
          _StockPreviewRow(item: preview[index]),
        ],
      ],
    );
  }
}

class _StockPreviewRow extends StatelessWidget {
  const _StockPreviewRow({required this.item});

  final DmStockItemModel item;

  @override
  Widget build(BuildContext context) {
    final metricStyle = AppTextStyles.caption(
      context,
    ).copyWith(color: AppColors.grey);

    return AppOutlineCard(
      statusColor: item.isLowStock ? AppColors.warning : AppColors.success,
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.012),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle(context),
          ),
          AppSpacing.vertical(context, 0.004),
          Text(AppTexts.dmStockLoadedLabel(item.quantity), style: metricStyle),
          Text(AppTexts.dmStockOnHandCount(item.onHand), style: metricStyle),
          if (item.isLowStock) ...[
            AppSpacing.vertical(context, 0.006),
            AppStatusChip.lowStock(),
          ],
        ],
      ),
    );
  }
}
