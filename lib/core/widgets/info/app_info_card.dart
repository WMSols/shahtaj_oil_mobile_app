import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    super.key,
    required this.title,
    required this.child,
    this.borderColor = AppColors.cardBorder,
  });

  final String title;
  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSpacing.verticalValue(context, 0.015)),
      padding: AppSpacing.all(context, factor: 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle(context)),
          AppSpacing.vertical(context, 0.015),
          child,
        ],
      ),
    );
  }
}
