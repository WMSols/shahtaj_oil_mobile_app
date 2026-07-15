import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

/// Shared section title row used across account, dashboard, and forms.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.bottomSpacing = false,
  });

  final String title;
  final VoidCallback? onViewAll;
  final bool bottomSpacing;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Expanded(
          child: Text(title, style: AppTextStyles.sectionTitle(context)),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(
              AppTexts.viewAll,
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(color: AppColors.primary),
            ),
          ),
      ],
    );

    if (!bottomSpacing) return row;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.verticalValue(context, 0.01)),
      child: row,
    );
  }
}
