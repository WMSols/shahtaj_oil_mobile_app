import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/tasks/ob_active_visit_banner.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_active_visit_controller.dart';

class ObActiveVisitScreen extends GetView<ObActiveVisitController> {
  const ObActiveVisitScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    final content = Obx(() {
      if (controller.isLoading.value) return const AppLoader();
      if (controller.error.value != null) {
        return AppEmptyState(
          title: AppTexts.obActiveVisitTitle,
          subtitle: controller.error.value!,
        );
      }
      final activeVisit = controller.activeVisit.value;
      if (activeVisit == null) {
        return AppEmptyState(
          title: AppTexts.obActiveVisitTitle,
          subtitle: AppTexts.obActiveVisitMissing,
        );
      }

      return ListView(
        padding: AppSpacing.screenPadding(context),
        children: [
          ObActiveVisitBanner(
            visit: activeVisit,
            onResume: controller.resumeVisit,
          ),
        ],
      );
    });

    if (embeddedInShell) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: content,
      );
    }
    return AppSubScreenScaffold(
      title: AppTexts.obActiveVisitTitle,
      body: content,
    );
  }
}
