import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.badge,
    this.iconColor = AppColors.textPrimary,
    this.backgroundColor = Colors.transparent,
    this.iconSize,
    this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String? badge;
  final Color iconColor;
  final Color backgroundColor;
  final double? iconSize;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final size = iconSize ?? AppResponsive.iconSize(context);
    final radius = BorderRadius.circular(AppResponsive.radius(context));

    return Material(
      color: backgroundColor,
      borderRadius: radius,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: radius,
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.01, v: 0.005),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (isLoading)
                SizedBox(
                  width: size,
                  height: size,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: iconColor,
                  ),
                )
              else
                Icon(icon, color: iconColor, size: size),
              if (!isLoading && badge != null && badge!.isNotEmpty)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: EdgeInsets.all(
                      AppResponsive.scaleSize(context, 4),
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge!,
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.white,
                        fontSize: AppResponsive.scaleSize(context, 10),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
