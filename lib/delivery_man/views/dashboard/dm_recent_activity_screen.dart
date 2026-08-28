import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/dashboard/dm_recent_activity_card.dart';

class DmRecentActivityScreen extends GetView<DmDashboardController> {
  const DmRecentActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmRecentActivity,
      body: Obx(() {
        final items = controller.recentActivity.toList(growable: false);
        if (items.isEmpty) {
          return AppEmptyState(
            title: AppTexts.emptyNoCollectionsTitle,
            subtitle: AppTexts.dmNoRecentActivity,
            image: AppImages.emptyNoCollections,
          );
        }

        return ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            DmRecentActivityCard(
              items: items,
              onItemTap: controller.openActivity,
            ),
          ],
        );
      }),
    );
  }
}
