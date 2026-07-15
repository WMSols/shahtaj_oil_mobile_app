import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
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
    this.presenceStatus,
    this.showPresenceDot = false,
  });

  final double size;
  final VoidCallback? onTap;
  final String name;
  final PresenceStatus? presenceStatus;
  final bool showPresenceDot;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = AppResponsive.scaleSize(context, size);
    final initials = AppHelper.initialsFromName(name);
    final dotSize = (resolvedSize * 0.28).clamp(8.0, 16.0);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: resolvedSize,
        height: resolvedSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
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
            if (showPresenceDot && presenceStatus != null)
              Positioned(
                right: 5,
                bottom: 0,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: presenceStatus!.chipColor,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
