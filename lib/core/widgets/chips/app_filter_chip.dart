import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.color = AppColors.primary,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  factory AppFilterChip.shopStatus({
    required ShopStatus status,
    required bool selected,
    required VoidCallback onTap,
  }) => AppFilterChip(
    label: status.label,
    color: status.chipColor,
    selected: selected,
    onTap: onTap,
  );

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? color : AppColors.white;
    final borderColor = selected ? color : AppColors.cardBorder;
    final textColor = selected ? AppColors.white : AppColors.grey;

    return Padding(
      padding: EdgeInsets.only(
        right: AppSpacing.horizontalValue(context, 0.02),
      ),
      child: Material(
        color: backgroundColor,
        shape: StadiumBorder(side: BorderSide(color: borderColor)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.horizontalValue(context, 0.04),
              vertical: AppSpacing.verticalValue(context, 0.008),
            ),
            child: Text(
              label,
              style: AppTextStyles.caption(context).copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
