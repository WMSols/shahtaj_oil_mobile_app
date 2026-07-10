import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_add_new_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_icon_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_view_timestamps_row.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_profile_avatar.dart';

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.createdAtLabel,
    this.createdAtValue,
    this.updatedAtLabel,
    this.updatedAtValue,
    this.showAddNew = false,
    this.onAddNew,
    this.onProfileTap,
    this.onNotificationTap,
    this.notificationBadge,
    this.userName = '',
  });

  final String title;
  final String? subtitle;
  final String? createdAtLabel;
  final String? createdAtValue;
  final String? updatedAtLabel;
  final String? updatedAtValue;
  final bool showAddNew;
  final VoidCallback? onAddNew;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final String? notificationBadge;
  final String userName;

  bool get _showTimestamps =>
      createdAtLabel != null &&
      createdAtValue != null &&
      updatedAtLabel != null &&
      updatedAtValue != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppProfileAvatar(
                size: AppResponsive.scaleSize(context, 34),
                onTap: onProfileTap,
                name: userName,
              ),
              const Spacer(),
              AppIconButton(
                icon: AppIcons.notification,
                badge: notificationBadge,
                iconSize: AppResponsive.iconSize(context, factor: 1.5),
                onTap: onNotificationTap,
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.015),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.screenTitle(context)),
                    if (subtitle != null) ...[
                      AppSpacing.vertical(context, 0.005),
                      Text(
                        subtitle!,
                        style: AppTextStyles.caption(context).copyWith(
                          fontSize: AppResponsive.scaleSize(context, 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showAddNew && onAddNew != null)
                AppAddNewChip(onTap: onAddNew!),
            ],
          ),
          if (_showTimestamps) ...[
            AppSpacing.vertical(context, 0.02),
            const Divider(color: AppColors.cardBorder, height: 1),
            AppSpacing.vertical(context, 0.01),
            AppViewTimestampsRow(
              createdAtLabel: createdAtLabel!,
              createdAtValue: createdAtValue!,
              updatedAtLabel: updatedAtLabel!,
              updatedAtValue: updatedAtValue!,
            ),
          ] else ...[
            AppSpacing.vertical(context, 0.01),
            const Divider(color: AppColors.cardBorder, height: 1),
          ],
        ],
      ),
    );
  }
}
