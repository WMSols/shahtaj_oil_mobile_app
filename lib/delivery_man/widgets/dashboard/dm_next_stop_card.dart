import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';

class DmNextStopCard extends StatelessWidget {
  const DmNextStopCard({
    super.key,
    required this.title,
    required this.amount,
    required this.onOpen,
    this.statusColor = AppColors.primary,
  });

  final String title;
  final String amount;
  final VoidCallback onOpen;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      statusColor: statusColor,
      onTap: onOpen,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.015),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.sectionTitle(context)),
                Text(
                  amount,
                  style: AppTextStyles.bodyText(
                    context,
                  ).copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          Icon(AppIcons.chevronRight, color: AppColors.primary),
        ],
      ),
    );
  }
}
