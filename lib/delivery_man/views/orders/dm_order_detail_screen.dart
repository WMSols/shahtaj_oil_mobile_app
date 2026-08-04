import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_order_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/shared/dm_order_detail_body.dart';

class DmOrderDetailScreen extends GetView<DmOrderDetailController> {
  const DmOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmOrderDetailTitle,
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();
        final order = controller.order.value;
        if (order == null) {
          return AppEmptyState(title: AppTexts.emptyNotFoundTitle);
        }

        return DmOrderDetailBody(
          order: order,
          editable: controller.canEditDelivery,
          canStartDelivery: controller.canStartDelivery,
          isActing: controller.isActing.value,
          deliveredDrafts: controller.deliveredDrafts,
          rejectedDrafts: controller.rejectedDrafts,
          onDeliveredChanged: controller.onDeliveredChanged,
          onRejectedChanged: controller.onRejectedChanged,
          receiverController: controller.receiverController,
          notesController: controller.notesController,
          proofPhotoBytes: controller.proofPhotoBytes.value,
          onPickProofPhoto: controller.pickProofPhoto,
          onStartDelivery: controller.startDelivery,
          onConfirmDelivery: controller.submitDelivery,
          showReadonlyProof: controller.isDone,
        );
      }),
    );
  }
}
