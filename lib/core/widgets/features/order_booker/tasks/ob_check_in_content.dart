import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_map_preview.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_task_model.dart';

class ObCheckInContent extends StatelessWidget {
  const ObCheckInContent({
    super.key,
    required this.task,
    required this.latitude,
    required this.longitude,
    this.shopLatitude,
    this.shopLongitude,
    required this.locationLabel,
    required this.hasLocation,
    required this.isLocating,
    required this.isSubmitting,
    required this.onUseCurrentLocation,
    required this.onCheckIn,
    required this.onSkip,
  });

  final ObTaskModel task;
  final double? latitude;
  final double? longitude;
  final double? shopLatitude;
  final double? shopLongitude;
  final String locationLabel;
  final bool hasLocation;
  final bool isLocating;
  final bool isSubmitting;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onCheckIn;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final mapLat = latitude ?? shopLatitude ?? task.shopLatitude;
    final mapLng = longitude ?? shopLongitude ?? task.shopLongitude;

    return ListView(
      padding: AppSpacing.screenPadding(context),
      children: [
        Text(
          task.shopName,
          style: AppTextStyles.sectionTitle(
            context,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
        if (task.ownerName != null) ...[
          AppSpacing.vertical(context, 0.006),
          Text(
            AppTexts.obShopOwner(task.ownerName!),
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(color: AppColors.grey),
          ),
        ],
        if (task.locationLabel != null) ...[
          AppSpacing.vertical(context, 0.006),
          Row(
            children: [
              Icon(
                AppIcons.location5,
                size: AppResponsive.iconSize(context, factor: 0.85),
                color: AppColors.primary,
              ),
              AppSpacing.horizontal(context, 0.01),
              Expanded(
                child: Text(
                  task.locationLabel!,
                  style: AppTextStyles.bodyText(context),
                ),
              ),
            ],
          ),
        ],
        AppSpacing.vertical(context, 0.016),
        Text(
          AppTexts.obCheckInShopContext,
          style: AppTextStyles.bodyText(
            context,
          ).copyWith(color: AppColors.grey),
        ),
        AppSpacing.vertical(context, 0.012),
        AppMapPreview(latitude: mapLat, longitude: mapLng),
        AppSpacing.vertical(context, 0.01),
        Text(
          locationLabel,
          style: AppTextStyles.bodyText(context).copyWith(
            color: hasLocation ? AppColors.textPrimary : AppColors.grey,
          ),
        ),
        AppSpacing.vertical(context, 0.01),
        AppSecondaryButton(
          label: AppTexts.obUseCurrentLocation,
          icon: AppIcons.gps,
          outlinedOnly: true,
          isLoading: isLocating,
          onPressed: isLocating ? null : onUseCurrentLocation,
        ),
        AppSpacing.vertical(context, 0.02),
        AppPrimaryButton(
          label: AppTexts.obTaskCheckIn,
          isLoading: isSubmitting,
          onPressed: isSubmitting || !hasLocation ? null : onCheckIn,
        ),
        AppSpacing.vertical(context, 0.01),
        AppSecondaryButton(
          label: AppTexts.obTaskSkip,
          outlinedOnly: true,
          onPressed: isSubmitting ? null : onSkip,
        ),
      ],
    );
  }
}
