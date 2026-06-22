import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class AppAddNewChip extends StatelessWidget {
  const AppAddNewChip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.scaleSize(context, 12),
          vertical: AppResponsive.scaleSize(context, 6),
        ),
        decoration: BoxDecoration(
          color: AppColors.accentBlue,
          borderRadius: BorderRadius.circular(
            AppResponsive.scaleSize(context, 20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.add,
              color: AppColors.white,
              size: AppResponsive.scaleSize(context, 16),
            ),
            AppSpacing.horizontal(context, 0.01),
            Text(
              AppTexts.addNew,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
