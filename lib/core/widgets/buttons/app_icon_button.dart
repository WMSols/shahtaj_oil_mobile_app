import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.badge,
    this.iconColor = AppColors.textPrimary,
    this.iconSize,
    this.padding,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String? badge;
  final Color iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final size = iconSize ?? AppResponsive.iconSize(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size),
        child: Padding(
          padding:
              padding ?? EdgeInsets.all(AppResponsive.scaleSize(context, 4)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: iconColor, size: size),
              if (badge != null && badge!.isNotEmpty)
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
