import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';

/// Hidden until a past-events / activity API exists.
class DmRecentActivityScreen extends GetView<DmDashboardController> {
  const DmRecentActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmRecentActivity,
      body: AppEmptyState(
        title: AppTexts.emptyNoCollectionsTitle,
        subtitle: AppTexts.dmNoRecentActivity,
        image: AppImages.emptyNoCollections,
      ),
    );
  }
}
