import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van_stock/dm_van_stock_document_model.dart';

class DmVanStockHistorySection extends StatelessWidget {
  const DmVanStockHistorySection({super.key, required this.history});

  final List<DmVanStockDocumentModel> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: AppTexts.dmVanHistoryTitle,
          bottomSpacing: true,
        ),
        for (final doc in history) ...[
          _HistoryCard(doc: doc),
          AppSpacing.vertical(context, 0.01),
        ],
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.doc});

  final DmVanStockDocumentModel doc;

  @override
  Widget build(BuildContext context) {
    final isLoad = doc.kind == DmVanStockDocumentKind.load;
    final color = isLoad ? AppColors.primary : AppColors.success;
    final label = isLoad
        ? AppTexts.dmVanHistoryLoad
        : AppTexts.dmVanHistoryUnload;
    final metricStyle = AppTextStyles.caption(
      context,
    ).copyWith(color: AppColors.grey);

    return AppOutlineCard(
      statusColor: color,
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.012),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppFormatter.dateTime(doc.at),
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              AppStatusChip(label: label, color: color),
            ],
          ),
          AppSpacing.vertical(context, 0.004),
          Text(
            AppTexts.dmVanHistoryQty(doc.totalQty, doc.items.length),
            style: metricStyle,
          ),
          if (doc.notes.isNotEmpty) ...[
            AppSpacing.vertical(context, 0.002),
            Text(doc.notes, style: metricStyle),
          ],
        ],
      ),
    );
  }
}
