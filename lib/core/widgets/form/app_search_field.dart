import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_field_label.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_input_decoration.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon = const Icon(AppIcons.search, color: AppColors.grey),
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.inputFormatters,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFormFieldLabel(label: label),
        AppSpacing.vertical(context, 0.01),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          autovalidateMode: autovalidateMode,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          decoration: AppInputDecoration.decoration(
            context,
            hintText: hint ?? AppTexts.search,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
          style: AppTextStyles.bodyText(context),
        ),
      ],
    );
  }
}
