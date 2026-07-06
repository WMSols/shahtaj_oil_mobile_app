import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class ObDashboardSectionHeader extends StatelessWidget {
  const ObDashboardSectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
  });

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
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
  }
}
