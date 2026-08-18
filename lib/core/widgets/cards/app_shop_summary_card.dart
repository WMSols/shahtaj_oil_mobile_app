import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_outline_icon_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';

class AppShopSummaryCard extends StatelessWidget {
  const AppShopSummaryCard({
    super.key,
    required this.name,
    required this.callLabel,
    required this.directionsLabel,
    required this.onCall,
    required this.onDirections,
    this.ownerName,
    this.phone,
    this.trailing,
    this.statusColor,
  });

  final String name;
  final String? ownerName;
  final String? phone;
  final Widget? trailing;
  final Color? statusColor;
  final String callLabel;
  final String directionsLabel;
  final VoidCallback? onCall;
  final VoidCallback? onDirections;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = AppTextStyles.bodyText(context);
    final owner = ownerName?.trim() ?? '';
    final phoneNumber = phone?.trim() ?? '';

    return AppOutlineCard(
      statusColor: statusColor,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.018),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(name, style: AppTextStyles.sectionTitle(context)),
              ),
              if (trailing != null) ...[
                AppSpacing.horizontal(context, 0.02),
                trailing!,
              ],
            ],
          ),
          if (owner.isNotEmpty || phoneNumber.isNotEmpty) ...[
            AppSpacing.vertical(context, 0.01),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.horizontalValue(context, 0.02),
              runSpacing: AppSpacing.verticalValue(context, 0.004),
              children: [
                if (owner.isNotEmpty)
                  _IconLabel(
                    icon: AppIcons.person5,
                    label: owner,
                    style: bodyStyle,
                  ),
                if (owner.isNotEmpty && phoneNumber.isNotEmpty)
                  Text('•', style: bodyStyle),
                if (phoneNumber.isNotEmpty)
                  _IconLabel(
                    icon: AppIcons.phone5,
                    label: phoneNumber,
                    style: bodyStyle,
                  ),
              ],
            ),
          ],
          AppSpacing.vertical(context, 0.016),
          Row(
            children: [
              AppOutlineIconButton(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                icon: AppIcons.phone5,
                label: callLabel,
                onTap: onCall,
              ),
              AppSpacing.horizontal(context, 0.015),
              AppOutlineIconButton(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                icon: AppIcons.routes5,
                label: directionsLabel,
                onTap: onDirections,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconLabel extends StatelessWidget {
  const _IconLabel({
    required this.icon,
    required this.label,
    required this.style,
  });

  final IconData icon;
  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppResponsive.iconSize(context, factor: 0.8),
          color: AppColors.primary,
        ),
        AppSpacing.horizontal(context, 0.008),
        Text(label, style: style),
      ],
    );
  }
}
