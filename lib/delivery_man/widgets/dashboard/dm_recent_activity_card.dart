import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_dashboard_activity_model.dart';

class DmRecentActivityCard extends StatelessWidget {
  const DmRecentActivityCard({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  final List<DmDashboardActivityItem> items;
  final ValueChanged<DmDashboardActivityItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) AppSpacing.vertical(context, 0.01),
          _ActivityRow(
            item: items[index],
            onTap: () => onItemTap(items[index]),
          ),
        ],
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item, required this.onTap});

  final DmDashboardActivityItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      onTap: onTap,
      statusColor: _stripeColor(item.kind),
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.015),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTextStyles.sectionTitle(context)),
                AppSpacing.vertical(context, 0.006),
                AppStatusChip(
                  label: _kindLabel(item.kind),
                  color: _stripeColor(item.kind),
                  soft: true,
                ),
              ],
            ),
          ),
          if (item.amount != null)
            Text(
              AppFormatter.currency(item.amount!, symbol: 'Rs. '),
              style: AppTextStyles.sectionTitle(context),
            ),
        ],
      ),
    );
  }

  Color _stripeColor(DmDashboardActivityKind kind) => switch (kind) {
    DmDashboardActivityKind.delivery => AppColors.success,
    DmDashboardActivityKind.collection => AppColors.primary,
    DmDashboardActivityKind.handover => AppColors.warning,
  };

  String _kindLabel(DmDashboardActivityKind kind) => switch (kind) {
    DmDashboardActivityKind.delivery => AppTexts.navDeliveries,
    DmDashboardActivityKind.collection => AppTexts.navCollections,
    DmDashboardActivityKind.handover => AppTexts.navHandover,
  };
}
