import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';

class AppProfileAvatar extends StatelessWidget {
  const AppProfileAvatar({super.key, this.size = 48, this.onTap});

  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppResponsive.scaleSize(context, size),
        height: AppResponsive.scaleSize(context, size),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.inputFill,
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          AppIcons.person,
          color: AppColors.textPrimary,
          size: AppResponsive.scaleSize(context, size / 2),
        ),
      ),
    );
  }
}
