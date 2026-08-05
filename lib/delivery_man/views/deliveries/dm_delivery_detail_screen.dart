import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/deliveries/dm_delivery_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/shared/dm_order_detail_body.dart';

class DmDeliveryDetailScreen extends GetView<DmDeliveryDetailController> {
  const DmDeliveryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmDeliveryDetailTitle,
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();
        final order = controller.delivery.value;
        if (order == null) {
          return AppEmptyState(title: AppTexts.emptyNotFoundTitle);
        }

        return DmOrderDetailBody(
          order: order,
          proofPhotoBytes: controller.proofPhotoBytes.value,
          showReadonlyProof: true,
        );
      }),
    );
  }
}
