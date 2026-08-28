import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_dashboard_activity_model.dart';

class DmNextActionCard extends StatelessWidget {
  const DmNextActionCard({
    super.key,
    required this.action,
    required this.onPressed,
  });

  final DmNextActionModel action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);
    final iconPad = AppResponsive.scaleSize(context, 8);
    final icon = switch (action.kind) {
      DmNextActionKind.pickup => AppIcons.pickups,
      DmNextActionKind.deliver => AppIcons.deliver,
      DmNextActionKind.unload => AppIcons.vanStock,
      DmNextActionKind.collect => AppIcons.collections,
      DmNextActionKind.handover => AppIcons.handover,
    };

    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(iconPad),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Icon(
                  icon,
                  color: AppColors.white,
                  size: AppResponsive.iconSize(context),
                ),
              ),
              AppSpacing.horizontal(context, 0.012),
              Expanded(
                child: Text(
                  action.message,
                  style: AppTextStyles.bodyText(context).copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.012),
          AppSecondaryButton(
            label: action.buttonLabel,
            onPressed: onPressed,
            borderColor: AppColors.white,
            textColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
