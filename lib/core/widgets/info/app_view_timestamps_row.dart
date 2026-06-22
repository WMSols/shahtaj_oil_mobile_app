import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppViewTimestampsRow extends StatelessWidget {
  const AppViewTimestampsRow({
    super.key,
    required this.createdAtLabel,
    required this.createdAtValue,
    required this.updatedAtLabel,
    required this.updatedAtValue,
  });

  final String createdAtLabel;
  final String createdAtValue;
  final String updatedAtLabel;
  final String updatedAtValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _TimestampColumn(label: createdAtLabel, value: createdAtValue),
        ),
        AppSpacing.horizontal(context, 0.02),
        Expanded(
          child: _TimestampColumn(label: updatedAtLabel, value: updatedAtValue),
        ),
      ],
    );
  }
}

class _TimestampColumn extends StatelessWidget {
  const _TimestampColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption(context).copyWith(
            fontSize: AppResponsive.scaleSize(context, 10),
            color: AppColors.grey,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyText(context).copyWith(
            fontSize: AppResponsive.scaleSize(context, 10),
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
