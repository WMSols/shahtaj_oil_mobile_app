import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelColor,
  });

  final bool value;
  final String? label;
  final ValueChanged<bool?>? onChanged;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final checkbox = Checkbox(
      value: value,
      onChanged: onChanged,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      activeColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
      ),
    );

    if (label == null) return checkbox;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        checkbox,
        Text(
          label!,
          style: AppTextStyles.labelText(
            context,
          ).copyWith(color: labelColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }
}
