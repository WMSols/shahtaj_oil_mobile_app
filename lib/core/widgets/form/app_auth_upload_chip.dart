import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppAuthUploadChip extends StatelessWidget {
  const AppAuthUploadChip({
    super.key,
    required this.label,
    this.icon = AppIcons.image,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.scaleSize(context, 28);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppSpacing.symmetric(context, h: 0.04, v: 0.014),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.hintText(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              icon,
              color: AppColors.grey,
              size: AppResponsive.scaleSize(context, 20),
            ),
          ],
        ),
      ),
    );
  }
}
