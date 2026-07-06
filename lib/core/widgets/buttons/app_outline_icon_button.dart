import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppOutlineIconButton extends StatelessWidget {
  const AppOutlineIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor = AppColors.white,
    this.foregroundColor = AppColors.primary,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);

    return Expanded(
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.cardBorder),
          borderRadius: BorderRadius.circular(radius),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: AppSpacing.symmetric(context, h: 0.01, v: 0.01),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: foregroundColor,
                  size: AppResponsive.iconSize(context, factor: 0.95),
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(context).copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.scaleSize(context, 11),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
