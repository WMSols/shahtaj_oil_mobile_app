import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.outlinedOnly = false,
    this.textColor,
    this.borderColor,
    this.icon,
    this.isLoading = false,
    this.labelStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool outlinedOnly;
  final Color? textColor;
  final Color? borderColor;
  final IconData? icon;
  final bool isLoading;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final resolvedBorderColor = borderColor ?? AppColors.primary;
    final resolvedTextColor = textColor ?? AppColors.primary;

    return SizedBox(
      width: double.infinity,
      height: AppResponsive.scaleSize(context, 40),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: outlinedOnly ? Colors.transparent : AppColors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: resolvedBorderColor, width: 1),
            borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: AppResponsive.buttonLoaderSize(context, factor: 0.3),
                height: AppResponsive.buttonLoaderSize(context, factor: 0.3),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: resolvedTextColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: resolvedTextColor,
                      size: AppResponsive.scaleSize(context, 18),
                    ),
                    SizedBox(width: AppResponsive.scaleSize(context, 8)),
                  ],
                  Text(
                    label,
                    style: (labelStyle ?? AppTextStyles.buttonText(context))
                        .copyWith(color: resolvedTextColor),
                  ),
                ],
              ),
      ),
    );
  }
}
