import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppFormSectionHeader extends StatelessWidget {
  const AppFormSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.required = false,
  });

  final IconData icon;
  final String title;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: AppResponsive.iconSize(context),
        ),
        AppSpacing.horizontal(context, 0.015),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title.toUpperCase(),
                  style: AppTextStyles.sectionTitleAccent(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (required)
                Text(
                  ' *',
                  style: AppTextStyles.sectionTitleAccent(context).copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
