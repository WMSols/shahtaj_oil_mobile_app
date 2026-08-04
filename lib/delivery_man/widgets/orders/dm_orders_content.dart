import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_orders_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/shared/dm_order_list_content.dart';

class DmOrdersContent extends GetView<DmOrdersController> {
  const DmOrdersContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DmOrderListContent(
        orders: controller.visibleOrders,
        onRefresh: controller.loadOrders,
        onQueryChanged: controller.onQueryChanged,
        onOrderTap: controller.openOrder,
        filterStatuses: controller.filterStatuses,
        isFilterSelected: controller.isFilterSelected,
        onFilterSelected: controller.selectFilter,
      ),
    );
  }
}
