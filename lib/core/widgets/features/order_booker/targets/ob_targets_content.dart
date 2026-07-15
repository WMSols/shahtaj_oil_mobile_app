import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/targets/ob_target_progress_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_async_body.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_targets_controller.dart';

class ObTargetsContent extends GetView<ObTargetsController> {
  const ObTargetsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppAsyncBody(
        isLoading: controller.isLoading.value,
        hasError: controller.error.value != null,
        isEmpty: controller.targets.isEmpty,
        errorMessage: controller.error.value,
        emptyTitle: AppTexts.emptyNoTargetsTitle,
        emptySubtitle: AppTexts.noDataYet,
        emptyImage: AppImages.emptyNoTargets,
        onRefresh: () => controller.load(force: true),
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: controller.targets
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(
                    bottom: AppSpacing.verticalValue(context, 0.01),
                  ),
                  child: ObTargetProgressCard(target: item),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}
