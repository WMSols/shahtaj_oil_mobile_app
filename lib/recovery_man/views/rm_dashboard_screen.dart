import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/recovery_man/dashboard/rm_recovery_target_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/rm_dashboard_controller.dart';

class RmDashboardScreen extends GetView<RmDashboardController> {
  const RmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoader();
        }

        return ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            Text(
              AppTexts.dashboardTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.vertical(context, 0.02),
            Text(
              AppTexts.rmTargets,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            AppSpacing.vertical(context, 0.01),
            RmRecoveryTargetCard(targets: controller.targets),
          ],
        );
      }),
    );
  }
}
