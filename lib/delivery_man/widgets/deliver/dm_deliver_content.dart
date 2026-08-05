import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/deliver/dm_deliver_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/shared/dm_order_list_content.dart';

class DmDeliverContent extends GetView<DmDeliverController> {
  const DmDeliverContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DmOrderListContent(
        orders: controller.visibleOrders,
        onRefresh: controller.loadActive,
        onQueryChanged: controller.onQueryChanged,
        onOrderTap: controller.openOrder,
        queryIsEmpty: controller.query.value.isEmpty,
        emptyWhenNoQueryTitle: AppTexts.dmNoInTransitOrders,
      ),
    );
  }
}
