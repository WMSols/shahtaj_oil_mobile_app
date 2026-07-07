import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/delivery_man/dashboard/dm_stock_items_section.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dm_dashboard_controller.dart';

class DmDashboardScreen extends GetView<DmDashboardController> {
  const DmDashboardScreen({super.key});

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
              AppTexts.dmStockItems,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            AppSpacing.vertical(context, 0.01),
            DmStockItemsSection(
              items: controller.stockItems,
              vanStockCount: controller.vanStockCount,
            ),
          ],
        );
      }),
    );
  }
}
