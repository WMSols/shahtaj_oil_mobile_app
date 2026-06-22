import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_field_label.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_input_decoration.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.required = false,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.borderColor,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final bool required;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? borderColor;

  Widget? _suffixWidget(BuildContext context) {
    if (suffixIcon == null) return null;

    final icon = Icon(
      suffixIcon,
      color: AppColors.grey,
      size: AppResponsive.scaleSize(context, 20),
    );

    if (onSuffixTap != null) {
      return IconButton(onPressed: onSuffixTap, icon: icon);
    }

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFormFieldLabel(label: label, required: required),
        if (label != null && label!.isNotEmpty)
          AppSpacing.vertical(context, 0.01),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          autovalidateMode: autovalidateMode,
          onChanged: onChanged,
          onFieldSubmitted: (value) {
            if (textInputAction == TextInputAction.next) {
              FocusScope.of(context).nextFocus();
            }
            onSubmitted?.call(value);
          },
          maxLines: maxLines,
          minLines: minLines,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTextStyles.bodyText(context),
          decoration: AppInputDecoration.decoration(
            context,
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixWidget ?? _suffixWidget(context),
            borderColor: borderColor,
          ),
        ),
      ],
    );
  }
}
