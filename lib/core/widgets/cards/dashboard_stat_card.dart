import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.iconAsset,
    this.backgroundColor = AppColors.statGrey,
    this.gradient,
    this.height,
    this.showBorder = false,
    this.compact = false,
    this.lightText = false,
  });

  final String label;
  final String value;
  final String iconAsset;
  final Color backgroundColor;
  final Gradient? gradient;
  final double? height;
  final bool showBorder;
  final bool compact;
  final bool lightText;

  @override
  Widget build(BuildContext context) {
    final hPad = AppResponsive.scaleSize(context, compact ? 10 : 12);
    final vPad = AppResponsive.scaleSize(context, compact ? 8 : 10);
    final labelSize =
        AppResponsive.screenWidth(context) * (compact ? 0.026 : 0.028);
    final iconSize = AppResponsive.scaleSize(context, compact ? 20 : 24);
    final fallbackHeight = AppResponsive.scaleSize(context, compact ? 72 : 96);
    final textColor = lightText ? AppColors.white : AppColors.textPrimary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedHeight =
            height ??
            (constraints.maxHeight.isFinite && constraints.maxHeight > 0
                ? constraints.maxHeight
                : fallbackHeight);

        return SizedBox(
          width: double.infinity,
          height: resolvedHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null ? backgroundColor : null,
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, factor: 2),
              ),
              border: showBorder
                  ? Border.all(color: AppColors.cardBorder)
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              child: compact
                  ? _CompactCardBody(
                      label: label,
                      value: value,
                      iconAsset: iconAsset,
                      labelSize: labelSize,
                      iconSize: iconSize,
                      textColor: textColor,
                    )
                  : _LargeCardBody(
                      label: label,
                      value: value,
                      iconAsset: iconAsset,
                      labelSize: labelSize,
                      iconSize: iconSize,
                      textColor: textColor,
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _LargeCardBody extends StatelessWidget {
  const _LargeCardBody({
    required this.label,
    required this.value,
    required this.iconAsset,
    required this.labelSize,
    required this.iconSize,
    required this.textColor,
  });

  final String label;
  final String value;
  final String iconAsset;
  final double labelSize;
  final double iconSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.statLabel(
                  context,
                ).copyWith(color: textColor, fontSize: labelSize, height: 1.2),
              ),
            ),
            AppSpacing.horizontal(context, 0.016),
            Image.asset(
              iconAsset,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth * 0.8,
                  height: constraints.maxHeight * 0.8,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      value,
                      style: AppTextStyles.statValue(context).copyWith(
                        color: textColor,
                        fontSize: constraints.maxHeight,
                        height: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactCardBody extends StatelessWidget {
  const _CompactCardBody({
    required this.label,
    required this.value,
    required this.iconAsset,
    required this.labelSize,
    required this.iconSize,
    required this.textColor,
  });

  final String label;
  final String value;
  final String iconAsset;
  final double labelSize;
  final double iconSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final valueSize = AppResponsive.screenWidth(context) * 0.065;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.statLabel(context).copyWith(
                    color: textColor,
                    fontSize: labelSize,
                    height: 1.2,
                  ),
                ),
              ),
              AppSpacing.horizontal(context, 0.016),
              Image.asset(
                iconAsset,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.statValue(
                context,
              ).copyWith(color: textColor, fontSize: valueSize, height: 1),
            ),
          ),
        ),
      ],
    );
  }
}
