import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/location_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

/// Sticky location/offline banners + transient toasts, stacked under the status
/// bar (same SafeArea + slide-from-top look for every message).
class AppTopFeedbackOverlay extends StatelessWidget {
  const AppTopFeedbackOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Touch Rx so Obx rebuilds for any of these.
      final _ = AppToast.overlayEpoch;
      final offline =
          Get.isRegistered<ConnectivityService>() &&
          !Get.find<ConnectivityService>().isOnline.value;
      final locationOff =
          Get.isRegistered<LocationService>() &&
          !Get.find<LocationService>().isLocationEnabled.value;
      final hasToast = AppToast.hasToast;

      // Keep the host mounted so exit slides can finish.
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSlideInBar(
                visible: locationOff,
                child: AppToastBar(
                  message: AppTexts.locationServicesOff,
                  style: AppToastStyle.warning,
                ),
              ),
              AppSlideInBar(
                visible: offline,
                child: AppToastBar(
                  message: AppTexts.noInternet,
                  style: AppToastStyle.error,
                ),
              ),
              AppSlideInBar(
                key: ValueKey('app-toast-slide-${AppToast.toastToken}'),
                visible: AppToast.isVisible,
                onExitComplete: AppToast.completeClose,
                child: hasToast
                    ? AppToastBar(
                        key: ValueKey('app-toast-${AppToast.toastToken}'),
                        message: AppToast.toastMessage,
                        style: AppToast.toastStyle,
                        showClose: AppToast.toastShowClose,
                        onClose: AppToast.close,
                        onSwipeDismissed: AppToast.completeClose,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// Alias kept for older imports; prefer [AppTopFeedbackOverlay].
typedef AppSystemStatusBanners = AppTopFeedbackOverlay;
