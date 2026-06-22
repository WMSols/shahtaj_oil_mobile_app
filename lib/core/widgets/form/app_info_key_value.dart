import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppInfoKeyValue extends StatelessWidget {
  const AppInfoKeyValue({
    super.key,
    required this.label,
    required this.value,
    this.valueAlign = TextAlign.start,
  });

  final String label;
  final String value;
  final TextAlign valueAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSpacing.verticalValue(context, 0.008),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppResponsive.screenWidth(context) * 0.35,
            child: Text(
              label,
              style: AppTextStyles.labelText(
                context,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyText(context),
              textAlign: valueAlign,
            ),
          ),
        ],
      ),
    );
  }
}
