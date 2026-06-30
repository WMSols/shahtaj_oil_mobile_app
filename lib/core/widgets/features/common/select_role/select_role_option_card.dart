import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class SelectRoleOptionCard extends StatelessWidget {
  const SelectRoleOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String imageAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);
    final imageWidth = AppResponsive.scaleSize(context, 160);
    final cardHeight = AppResponsive.scaleSize(context, 140);
    final textColor = selected ? AppColors.white : AppColors.black;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: cardHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.sectionTitle(
                        context,
                      ).copyWith(color: textColor),
                    ),
                    AppSpacing.vertical(context, 0.005),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: imageWidth,
              height: cardHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border(
                    right: BorderSide(
                      color: selected
                          ? AppColors.primary
                          : AppColors.cardBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: Image.asset(imageAsset, fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
