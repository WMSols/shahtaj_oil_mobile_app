import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';

class AppBaseCard extends StatelessWidget {
  const AppBaseCard({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: AppSpacing.verticalValue(context, 0.015),
        ),
        padding: AppSpacing.all(context),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, factor: 5),
          ),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: child,
      ),
    );
  }
}
