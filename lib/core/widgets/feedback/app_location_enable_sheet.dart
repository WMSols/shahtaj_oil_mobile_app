import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/location_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';

enum AppLocationGuideKind { serviceDisabled, permissionDenied }

/// Guides the user to turn on device location / grant permission (all platforms).
class AppLocationEnableSheet extends StatelessWidget {
  const AppLocationEnableSheet({super.key, required this.kind});

  final AppLocationGuideKind kind;

  static Future<void> show(AppLocationGuideKind kind) {
    return Get.bottomSheet<void>(
      AppLocationEnableSheet(kind: kind),
      isScrollControlled: true,
      backgroundColor: AppColors.white,
    );
  }

  String get _title => kind == AppLocationGuideKind.serviceDisabled
      ? AppTexts.locationEnableTitle
      : AppTexts.locationPermissionTitle;

  String get _message => kind == AppLocationGuideKind.serviceDisabled
      ? AppTexts.locationEnableMessage
      : AppTexts.locationPermissionMessage;

  String get _actionLabel => kind == AppLocationGuideKind.serviceDisabled
      ? AppTexts.locationOpenSettings
      : AppTexts.locationOpenAppSettings;

  Future<void> _openSettings() async {
    if (Get.isRegistered<LocationService>()) {
      final service = Get.find<LocationService>();
      if (kind == AppLocationGuideKind.serviceDisabled) {
        await service.openLocationSettings();
      } else {
        await service.openAppSettings();
      }
    } else if (kind == AppLocationGuideKind.serviceDisabled) {
      await Geolocator.openLocationSettings();
    } else {
      await Geolocator.openAppSettings();
    }
    if (Get.isBottomSheetOpen == true) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.horizontalValue(context, 0.04),
          right: AppSpacing.horizontalValue(context, 0.04),
          top: AppSpacing.verticalValue(context, 0.02),
          bottom:
              MediaQuery.viewInsetsOf(context).bottom +
              AppSpacing.verticalValue(context, 0.02),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              AppIcons.locationPin,
              color: AppColors.primary,
              size: AppResponsive.iconSize(context, factor: 1.6),
            ),
            AppSpacing.vertical(context, 0.012),
            Text(
              _title,
              style: AppTextStyles.heading(context),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vertical(context, 0.012),
            Text(
              _message,
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vertical(context, 0.008),
            Text(
              AppTexts.locationEnableSteps,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.darkGrey),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vertical(context, 0.016),
            AppPrimaryButton(label: _actionLabel, onPressed: _openSettings),
            AppSpacing.vertical(context, 0.008),
            AppSecondaryButton(
              label: AppTexts.cancel,
              outlinedOnly: true,
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
