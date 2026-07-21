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
    this.focusNode,
    this.initialValue,
    this.label,
    required this.hint,
    this.required = false,
    this.prefixIcon,
    this.pakistanPhonePrefix = false,
    this.suffixIcon,
    this.borderless = false,
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
    this.errorText,
    this.borderColor,
    this.fillColor,
    this.labelColor,
    this.textColor,
    this.hintColor,
    this.focusedBorderColor,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? label;
  final String hint;
  final bool required;
  final IconData? prefixIcon;
  final bool pakistanPhonePrefix;
  final IconData? suffixIcon;
  final bool borderless;
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
  final String? errorText;
  final Color? borderColor;
  final Color? fillColor;
  final Color? labelColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? focusedBorderColor;

  Widget? _suffixWidget(BuildContext context) {
    if (suffixIcon == null) return null;

    final icon = Icon(
      suffixIcon,
      color: AppColors.black,
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
        AppFormFieldLabel(label: label, required: required, color: labelColor),
        if (label != null && label!.isNotEmpty)
          AppSpacing.vertical(context, 0.005),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
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
          style: AppTextStyles.bodyText(context).copyWith(color: textColor),
          decoration: AppInputDecoration.decoration(
            context,
            hintText: hint,
            prefixIcon: prefixIcon,
            prefixText: pakistanPhonePrefix ? '+92' : null,
            suffixIcon: suffixWidget ?? _suffixWidget(context),
            fillColor: fillColor,
            borderColor: borderColor,
            hintStyle: hintColor != null
                ? AppTextStyles.hintText(context).copyWith(color: hintColor)
                : null,
            focusedBorderColor: focusedBorderColor,
            borderless: borderless,
          ).copyWith(errorText: errorText, errorMaxLines: 3),
        ),
      ],
    );
  }
}
