import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppFABButton extends StatelessWidget {
  const AppFABButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = AppIcons.add,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.white,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final iconSize = AppResponsive.iconSize(context);
    final textStyle = AppTextStyles.bodyText(
      context,
    ).copyWith(color: foregroundColor, fontWeight: FontWeight.w600);

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      elevation: 10,
      icon: Icon(icon, color: foregroundColor, size: iconSize),
      label: Text(label, style: textStyle),
    );
  }
}
