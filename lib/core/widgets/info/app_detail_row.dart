import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppDetailRow extends StatelessWidget {
  const AppDetailRow({
    super.key,
    required this.label,
    this.value,
    this.subtitle,
    this.valueColor,
    this.valueWeight = FontWeight.w500,
    this.trailing,
    this.showDivider = true,
  });

  final String label;
  final String? value;
  final String? subtitle;
  final Color? valueColor;
  final FontWeight valueWeight;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.bodyText(
      context,
    ).copyWith(color: AppColors.black);
    final valueStyle = AppTextStyles.bodyText(context).copyWith(
      color: valueColor ?? AppColors.textPrimary,
      fontWeight: valueWeight,
    );

    return Column(
      children: [
        Padding(
          padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: labelStyle),
                    if (subtitle != null) ...[
                      AppSpacing.vertical(context, 0.004),
                      Text(
                        subtitle!,
                        style: AppTextStyles.hintText(context).copyWith(
                          fontSize: AppResponsive.scaleSize(context, 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (value != null)
                Flexible(
                  child: Text(
                    value!,
                    style: valueStyle,
                    textAlign: TextAlign.start,
                  ),
                ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.cardBorder),
      ],
    );
  }
}
