import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

/// Reusable "Remember me" checkbox used on role login screens.
class AppRememberMe extends StatelessWidget {
  const AppRememberMe({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.textColor = AppColors.white,
    this.activeColor = AppColors.white,
    this.checkColor = AppColors.primary,
    this.borderColor = AppColors.white,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final Color textColor;
  final Color activeColor;
  final Color checkColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final size = AppResponsive.scaleSize(context, 20);

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
      child: Padding(
        padding: AppSpacing.symmetric(context, h: 0.004, v: 0.006),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: value ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, factor: 0.6),
                ),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: value
                  ? Icon(Icons.check, size: size * 0.75, color: checkColor)
                  : null,
            ),
            AppSpacing.horizontal(context, 0.02),
            Flexible(
              child: Text(
                label ?? AppTexts.rememberMe,
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(color: textColor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
