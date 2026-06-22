import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_field_label.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_input_decoration.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    this.label,
    this.hint,
    this.required = false,
    this.prefixIcon,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.getLabel,
  });

  final String? label;
  final String? hint;
  final bool required;
  final IconData? prefixIcon;
  final T? value;
  final List<T> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final AutovalidateMode autovalidateMode;
  final String Function(T)? getLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFormFieldLabel(label: label, required: required),
        if (label != null && label!.isNotEmpty)
          AppSpacing.vertical(context, 0.01),
        DropdownButtonFormField<T>(
          isExpanded: true,
          autovalidateMode: autovalidateMode,
          initialValue: value,
          hint: hint != null
              ? Text(hint!, style: AppTextStyles.hintText(context))
              : null,
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    getLabel != null ? getLabel!(e) : e.toString(),
                    style: AppTextStyles.bodyText(context),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: AppInputDecoration.decoration(
            context,
            prefixIcon: prefixIcon,
          ),
          icon: Icon(
            AppIcons.arrowDown,
            size: AppResponsive.iconSize(context),
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
