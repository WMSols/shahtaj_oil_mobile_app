import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppInputDecoration {
  AppInputDecoration._();

  static InputDecoration decoration(
    BuildContext context, {
    required String hintText,
    IconData? prefixIcon,
    Widget? prefixIconWidget,
    String? prefixText,
    Widget? suffixIcon,
    Color? fillColor,
    Color? borderColor,
    TextStyle? hintStyle,
    TextStyle? textStyle,
    Color? focusedBorderColor,
    bool borderless = false,
  }) {
    final radius = AppResponsive.radius(context, factor: 1);
    final fill = fillColor ?? AppColors.inputFill;
    final border = borderColor ?? AppColors.cardBorder;
    final idleBorder = borderless ? BorderSide.none : BorderSide(color: border);

    final prefix =
        prefixIconWidget ??
        _buildPrefixIcon(context, icon: prefixIcon, text: prefixText);

    return InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle ?? AppTextStyles.hintText(context),
      prefixIcon: prefix,
      prefixIconConstraints: BoxConstraints(
        minWidth: AppResponsive.scaleSize(context, prefix != null ? 36 : 0),
        minHeight: AppResponsive.scaleSize(context, 40),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: idleBorder,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: idleBorder,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: focusedBorderColor ?? AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: AppSpacing.symmetric(context, h: 0.04, v: 0.008),
    );
  }

  static Widget? _buildPrefixIcon(
    BuildContext context, {
    IconData? icon,
    String? text,
  }) {
    if (icon == null && text == null) return null;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.horizontalValue(context, 0.03),
        right: AppSpacing.horizontalValue(context, 0.01),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: AppResponsive.scaleSize(context, 20),
              color: AppColors.black,
            ),
          if (icon != null && text != null)
            SizedBox(width: AppResponsive.scaleSize(context, 4)),
          if (text != null)
            Text(
              text,
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }
}
