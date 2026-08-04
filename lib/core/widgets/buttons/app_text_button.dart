import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.accentBlue,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: AppResponsive.scaleSize(context, 18),
              height: AppResponsive.scaleSize(context, 18),
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            )
          : Text(
              label,
              style: AppTextStyles.bodyText(context).copyWith(color: color),
            ),
    );
  }
}
