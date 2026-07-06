import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.labelStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppResponsive.scaleSize(context, 40),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: AppResponsive.buttonLoaderSize(context, factor: 0.3),
                height: AppResponsive.buttonLoaderSize(context, factor: 0.3),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: AppColors.white,
                      size: AppResponsive.scaleSize(context, 18),
                    ),
                    SizedBox(width: AppResponsive.scaleSize(context, 8)),
                  ],
                  Text(
                    label,
                    style: (labelStyle ?? AppTextStyles.buttonText(context))
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
