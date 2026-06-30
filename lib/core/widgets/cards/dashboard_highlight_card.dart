import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class DashboardHighlightCard extends StatelessWidget {
  const DashboardHighlightCard({
    super.key,
    required this.label,
    required this.amount,
    this.iconAsset = AppImages.rupees,
  });

  final String label;
  final String amount;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.018),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 2),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            iconAsset,
            width: AppResponsive.scaleSize(context, 56),
            height: AppResponsive.scaleSize(context, 56),
            fit: BoxFit.contain,
          ),
          AppSpacing.horizontal(context, 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.statLabel(
                    context,
                  ).copyWith(color: AppColors.white),
                ),
                AppSpacing.vertical(context, 0.004),
                Text(
                  amount,
                  style: AppTextStyles.statValue(
                    context,
                  ).copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
