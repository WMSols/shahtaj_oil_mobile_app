import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';

class OnboardingProgressBar extends StatelessWidget {
  const OnboardingProgressBar({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });

  final int pageCount;
  final int currentPage;

  double get _progress => (currentPage + 1) / pageCount;

  @override
  Widget build(BuildContext context) {
    final height = AppResponsive.scaleSize(context, 5);

    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: AppColors.primary.withValues(alpha: 0.3)),
            TweenAnimationBuilder<double>(
              tween: Tween(end: _progress),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              builder: (context, value, _) {
                return FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: value.clamp(0.0, 1.0),
                  child: const ColoredBox(color: AppColors.primary),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
