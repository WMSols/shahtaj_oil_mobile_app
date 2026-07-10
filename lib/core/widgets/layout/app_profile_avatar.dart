import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';

class AppProfileAvatar extends StatelessWidget {
  const AppProfileAvatar({
    super.key,
    this.size = 48,
    this.onTap,
    this.name = '',
  });

  final double size;
  final VoidCallback? onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = AppResponsive.scaleSize(context, size);
    final initials = AppHelper.initialsFromName(name);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: resolvedSize,
        height: resolvedSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: AppTextStyles.sectionTitle(context).copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: resolvedSize * 0.36,
          ),
        ),
      ),
    );
  }
}
