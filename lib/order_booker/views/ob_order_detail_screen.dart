import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/orders/ob_order_detail_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_order_detail_controller.dart';

class ObOrderDetailScreen extends GetView<ObOrderDetailController> {
  const ObOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.obOrderDetailTitle,
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();
        if (controller.error.value != null || controller.order.value == null) {
          return AppEmptyState(
            title: AppTexts.obOrderDetailTitle,
            subtitle: controller.error.value ?? AppTexts.error,
          );
        }
        return const ObOrderDetailContent();
      }),
    );
  }
}
