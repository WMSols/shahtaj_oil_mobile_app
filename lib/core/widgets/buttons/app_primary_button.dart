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
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppResponsive.scaleSize(context, 52),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppResponsive.scaleSize(context, 28),
            ),
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
            : Text(label, style: AppTextStyles.buttonText(context)),
      ),
    );
  }
}
