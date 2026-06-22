import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppInputDecoration {
  AppInputDecoration._();

  static InputDecoration decoration(
    BuildContext context, {
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
    Color? borderColor,
  }) {
    final radius = AppResponsive.radius(context, factor: 5);
    final fill = fillColor ?? AppColors.inputFill;
    final border = borderColor ?? AppColors.cardBorder;

    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.hintText(context),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              size: AppResponsive.scaleSize(context, 20),
              color: AppColors.grey,
            )
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: AppColors.accentBlue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: AppSpacing.symmetric(context, h: 0.04, v: 0.014),
    );
  }
}
