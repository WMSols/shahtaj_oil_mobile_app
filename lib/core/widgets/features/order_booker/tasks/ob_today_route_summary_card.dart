import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_model.dart';

class ObTodayRouteSummaryCard extends StatelessWidget {
  const ObTodayRouteSummaryCard({super.key, required this.route});

  final ObRouteModel route;

  bool get _isActive => route.status == RouteStatus.inProgress;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      width: double.infinity,
      statusColor: route.status.chipColor,
      color: _isActive
          ? AppColors.primary.withValues(alpha: 0.08)
          : AppColors.white,
      borderColor: AppColors.lightGrey,
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
          AppSpacing.vertical(context, 0.008),
          Row(
            children: [
              Icon(
                AppIcons.shops,
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
        ],
      ),
    );
  }
}
