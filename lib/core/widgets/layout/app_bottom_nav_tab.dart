import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_bottom_nav_item.dart';

class AppBottomNavTab extends StatelessWidget {
  const AppBottomNavTab({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconSize = AppResponsive.scaleSize(context, 34);
    final indicatorWidth = AppResponsive.scaleSize(context, 28);
    final indicatorHeight = AppResponsive.scaleSize(context, 3);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppResponsive.scaleSize(context, 10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                selected ? item.active : item.inactive,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
              ),
              SizedBox(height: AppResponsive.scaleSize(context, 6)),
              Container(
                width: indicatorWidth,
                height: indicatorHeight,
                decoration: BoxDecoration(
                  color: selected ? AppColors.accentBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(indicatorHeight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
