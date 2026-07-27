import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

/// Persistent offline indicator pinned just below the status bar.
/// Prefer [AppTopFeedbackOverlay] in the root stack.
class AppConnectivityBanner extends StatelessWidget {
  const AppConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!Get.isRegistered<ConnectivityService>()) {
        return const SizedBox.shrink();
      }

      final offline = !Get.find<ConnectivityService>().isOnline.value;

      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        child: SafeArea(
          bottom: false,
          child: AppSlideInBar(
            visible: offline,
            child: AppToastBar(
              message: AppTexts.noInternet,
              style: AppToastStyle.error,
            ),
          ),
        ),
      );
    });
  }
}
