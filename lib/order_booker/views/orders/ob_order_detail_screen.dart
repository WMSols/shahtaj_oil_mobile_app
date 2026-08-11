import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/orders/ob_order_detail_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/orders/ob_order_detail_controller.dart';

class ObOrderDetailScreen extends GetView<ObOrderDetailController> {
  const ObOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.obOrderDetailTitle,
      body: Obx(() {
        if (controller.isLoading.value) {
          return AppShimmerSkeletons.detail(context);
        }
        if (controller.error.value != null || controller.order.value == null) {
          return AppEmptyState(
            title: controller.error.value != null
                ? AppTexts.emptyLoadFailedTitle
                : AppTexts.emptyNotFoundTitle,
            subtitle: controller.error.value ?? AppTexts.error,
            image: controller.error.value != null
                ? AppImages.emptyError
                : AppImages.emptyNotFound,
          );
        }
        return const ObOrderDetailContent();
      }),
    );
  }
}
