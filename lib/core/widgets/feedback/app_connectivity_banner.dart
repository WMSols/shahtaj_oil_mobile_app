import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

/// Persistent offline indicator pinned to the bottom of the screen.
class AppConnectivityBanner extends StatelessWidget {
  const AppConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ConnectivityService>()) {
      return const SizedBox.shrink();
    }

    final connectivity = Get.find<ConnectivityService>();

    return Obx(() {
      if (connectivity.isOnline.value) return const SizedBox.shrink();

      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: AppToastBar(
          message: AppTexts.noInternet,
          style: AppToastStyle.warning,
        ),
      );
    });
  }
}
