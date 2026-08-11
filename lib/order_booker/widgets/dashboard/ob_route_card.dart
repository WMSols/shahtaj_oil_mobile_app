import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/tasks/ob_today_tasks_progress.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/schedule/ob_route_model.dart';

class ObRouteCard extends StatelessWidget {
  const ObRouteCard({
    super.key,
    required this.route,
    this.onActionTap,
    this.onTap,
    this.showAction = true,
    this.completedTasks,
    this.totalTasks,
  });

  final ObRouteModel route;
  final VoidCallback? onActionTap;
  final VoidCallback? onTap;
  final bool showAction;
  final int? completedTasks;
  final int? totalTasks;

  bool get _hasAction =>
      showAction &&
      onActionTap != null &&
      route.status != RouteStatus.completed;
  bool get _isActive => route.status == RouteStatus.inProgress;
  bool get _showProgress =>
      totalTasks != null && totalTasks! > 0 && completedTasks != null;

  @override
  Widget build(BuildContext context) {
    final titleColor = _isActive ? AppColors.white : AppColors.textPrimary;
    final metaColor = _isActive
        ? AppColors.white.withValues(alpha: 0.9)
        : AppColors.grey;
    final iconColor = _isActive ? AppColors.white : route.status.chipColor;

    return AppOutlineCard(
      onTap: onTap,
      width: double.infinity,
      statusColor: _isActive ? null : route.status.chipColor,
      color: _isActive ? AppColors.primary : AppColors.white,
      borderColor: _isActive ? AppColors.primary : AppColors.lightGrey,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  route.name,
                  style: AppTextStyles.sectionTitle(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600, color: titleColor),
                ),
              ),
              if (_isActive)
                AppStatusChip(
                  label: route.status.label,
                  color: AppColors.white,
                  soft: true,
                )
              else
                AppStatusChip.route(route.status),
            ],
          ),
          if (!showAction) AppSpacing.vertical(context, 0.008),
          Row(
            children: [
              Icon(
                (!showAction || route.status != RouteStatus.completed)
                    ? AppIcons.shops
                    : AppIcons.check,
                color: iconColor,
                size: AppResponsive.iconSize(context),
              ),
              AppSpacing.horizontal(context, 0.01),
              Text(
                AppTexts.obShopsCount(route.shopCount),
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(color: metaColor),
              ),
            ],
          ),
          if (_showProgress) ...[
            AppSpacing.vertical(context, 0.012),
            ObTodayTasksProgress(
              completed: completedTasks!,
              total: totalTasks!,
              onPrimary: _isActive,
            ),
          ],
          if (_hasAction) ...[
            AppSpacing.vertical(context, 0.01),
            if (_isActive)
              AppSecondaryButton(
                label: AppTexts.obContinueTodayTasks,
                onPressed: onActionTap,
                borderColor: AppColors.white,
                textColor: AppColors.primary,
              )
            else
              AppPrimaryButton(
                label: AppTexts.obOpenTodayTasks,
                onPressed: onActionTap,
              ),
          ],
        ],
      ),
    );
  }
}
