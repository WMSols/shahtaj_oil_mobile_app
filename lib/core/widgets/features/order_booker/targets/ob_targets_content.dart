import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/targets/ob_target_progress_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_targets_controller.dart';

class ObTargetsContent extends GetView<ObTargetsController> {
  const ObTargetsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) return const AppLoader();
      if (controller.error.value != null) {
        return AppEmptyState(
          title: AppTexts.obTargets,
          subtitle: controller.error.value!,
        );
      }
      if (controller.targets.isEmpty) {
        return AppEmptyState(
          title: AppTexts.obTargets,
          subtitle: AppTexts.noDataYet,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.load,
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
