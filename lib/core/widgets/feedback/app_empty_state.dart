import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.image = AppImages.empty,
    this.actionLabel,
    this.onAction,
    this.onRefresh,
  });

  final String title;
  final String? subtitle;
  final String image;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final imageSize = AppResponsive.emptyIconSize(context) * 0.7;

    final content = Center(
      child: Padding(
        padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
            AppSpacing.vertical(context, 0.02),
            Text(
              title,
              style: AppTextStyles.heading(context),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              AppSpacing.vertical(context, 0.01),
              Text(
                subtitle!,
                style: AppTextStyles.hintText(context),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.vertical(context, 0.015),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: AppTextStyles.bodyText(
                    context,
                  ).copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (onRefresh == null) return content;

    return RefreshIndicator(
      onRefresh: onRefresh!,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: content,
            ),
          );
        },
      ),
    );
  }
}
