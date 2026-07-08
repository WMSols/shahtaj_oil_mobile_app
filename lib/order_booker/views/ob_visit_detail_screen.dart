import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/history/ob_visit_detail_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_visit_detail_controller.dart';

class ObVisitDetailScreen extends GetView<ObVisitDetailController> {
  const ObVisitDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.obVisitDetailTitle,
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();

        if (controller.error.value != null || controller.visit.value == null) {
          return AppEmptyState(
            title: AppTexts.obVisitDetailTitle,
            subtitle: controller.error.value ?? AppTexts.obVisitNotFound,
          );
        }

        return const ObVisitDetailContent();
      }),
    );
  }
}
