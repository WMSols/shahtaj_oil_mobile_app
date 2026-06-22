import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_field_label.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_input_decoration.dart';

class AppDateDisplayField extends StatelessWidget {
  const AppDateDisplayField({
    super.key,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.icon,
    this.required = false,
  });

  final String label;
  final String value;
  final String placeholder;
  final VoidCallback onTap;
  final IconData? icon;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final display = value.isEmpty ? placeholder : value;
    final isEmpty = value.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFormFieldLabel(label: label, required: required),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
          child: InputDecorator(
            decoration: AppInputDecoration.decoration(
              context,
              prefixIcon: icon ?? AppIcons.calendar,
            ),
            child: Text(
              display,
              style: isEmpty
                  ? AppTextStyles.hintText(context)
                  : AppTextStyles.bodyText(context),
            ),
          ),
        ),
      ],
    );
  }
}
