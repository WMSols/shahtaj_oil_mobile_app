import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/tasks/ob_check_in_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_check_in_controller.dart';

class ObCheckInScreen extends GetView<ObCheckInController> {
  const ObCheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.obCheckInTitle,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoader();
        }

        final task = controller.task.value;
        if (task == null) {
          return AppEmptyState(
            title: AppTexts.emptyNotFoundTitle,
            subtitle: AppTexts.obTaskNotFound,
            image: AppImages.emptyNotFound,
          );
        }

        return ObCheckInContent(
          task: task,
          latitude: controller.checkInLatitude.value,
          longitude: controller.checkInLongitude.value,
          shopLatitude: controller.shopLatitude,
          shopLongitude: controller.shopLongitude,
          locationLabel: controller.locationLabel,
          hasLocation: controller.hasDeviceLocation,
          isLocating: controller.isLocating.value,
          isSubmitting: controller.isSubmitting.value,
          onUseCurrentLocation: controller.useCurrentLocation,
          onCheckIn: controller.checkIn,
          onSkip: controller.confirmSkip,
        );
      }),
    );
  }
}
