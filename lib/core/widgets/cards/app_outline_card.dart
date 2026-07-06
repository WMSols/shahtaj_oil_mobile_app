import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';

class AppOutlineCard extends StatelessWidget {
  const AppOutlineCard({
    super.key,
    required this.child,
    this.padding,
    this.color = AppColors.white,
    this.clipBehavior = Clip.none,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehavior,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: child,
    );
  }
}
