import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_info_inline_field.dart';

class AppInfoInlinePairRow extends StatelessWidget {
  const AppInfoInlinePairRow({
    super.key,
    required this.firstLabel,
    required this.firstValue,
    required this.secondLabel,
    required this.secondValue,
  });

  final String firstLabel;
  final String firstValue;
  final String secondLabel;
  final String secondValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppInfoInlineField(
            label: firstLabel,
            value: firstValue,
          ),
        ),
        AppSpacing.horizontal(context, 0.02),
        Expanded(
          child: AppInfoInlineField(
            label: secondLabel,
            value: secondValue,
          ),
        ),
      ],
    );
  }
}
