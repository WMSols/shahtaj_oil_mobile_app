import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';

class ObVisitHeaderCard extends StatelessWidget {
  const ObVisitHeaderCard({
    super.key,
    required this.shopName,
    required this.visitId,
  });

  final String shopName;
  final int visitId;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      color: AppColors.primary.withValues(alpha: 0.07),
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.015),
      child: Row(
        children: [
          Icon(AppIcons.check, color: AppColors.primary),
          AppSpacing.horizontal(context, 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopName,
                  style: AppTextStyles.sectionTitle(
                    context,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
                AppSpacing.vertical(context, 0.003),
                Text(
                  AppTexts.obVisitLoadedFor(visitId),
                  style: AppTextStyles.caption(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
