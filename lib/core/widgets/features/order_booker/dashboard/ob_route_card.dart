import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_model.dart';

class ObRouteCard extends StatelessWidget {
  const ObRouteCard({super.key, required this.route, this.onActionTap});

  final ObRouteModel route;
  final VoidCallback? onActionTap;

  bool get _hasAction => route.status != RouteStatus.completed;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);
    final isActive = route.status == RouteStatus.inProgress;
    final activeStripeWidth = AppSpacing.horizontalValue(context, 0.01);

    final content = Padding(
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
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              AppStatusChip.route(route.status),
            ],
          ),
          Row(
            children: [
              Icon(
                route.status == RouteStatus.completed
                    ? AppIcons.checkCircle
                    : AppIcons.shops,
                color: route.status.chipColor,
                size: AppResponsive.iconSize(context),
              ),
              AppSpacing.horizontal(context, 0.01),
              Text(
                AppTexts.obShopsDistance(
                  route.shopCount,
                  route.distanceKm.toStringAsFixed(1),
                ),
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.grey),
              ),
            ],
          ),
          if (_hasAction) ...[
            AppSpacing.vertical(context, 0.01),
            AppPrimaryButton(
              label: route.status == RouteStatus.inProgress
                  ? AppTexts.obContinueRoute
                  : AppTexts.obStartRoute,
              onPressed: onActionTap,
            ),
          ],
        ],
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.white,
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Stack(
          children: [
            if (isActive)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: activeStripeWidth,
                  color: AppColors.primary,
                ),
              ),
            content,
          ],
        ),
      ),
    );
  }
}
