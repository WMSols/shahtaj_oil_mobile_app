import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppFormFieldLabel extends StatelessWidget {
  const AppFormFieldLabel({super.key, this.label, this.required = false});

  final String? label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    if (label == null || label!.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label!, style: AppTextStyles.sectionTitle(context)),
            if (required)
              Text(
                ' *',
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(fontWeight: FontWeight.w500, color: AppColors.error),
              ),
          ],
        ),
        AppSpacing.vertical(context, 0.003),
      ],
    );
  }
}
