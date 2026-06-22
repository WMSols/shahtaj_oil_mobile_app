import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.inbox,
              size: AppResponsive.emptyIconSize(context) * 0.5,
              color: AppColors.grey,
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
          ],
        ),
      ),
    );
  }
}
