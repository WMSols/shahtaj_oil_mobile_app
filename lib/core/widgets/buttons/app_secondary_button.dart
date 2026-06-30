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
  });

  final String label;
  final VoidCallback? onPressed;
  final bool outlinedOnly;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final resolvedBorderColor = borderColor ?? AppColors.primary;
    final resolvedTextColor = textColor ?? AppColors.primary;

    return SizedBox(
      width: double.infinity,
      height: AppResponsive.scaleSize(context, 40),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: outlinedOnly ? Colors.transparent : AppColors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: resolvedBorderColor, width: 1),
            borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonText(
            context,
          ).copyWith(color: resolvedTextColor),
        ),
      ),
    );
  }
}
