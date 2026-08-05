import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/deliveries/dm_deliveries_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/shared/dm_order_list_content.dart';

class DmDeliveriesContent extends GetView<DmDeliveriesController> {
  const DmDeliveriesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DmOrderListContent(
        orders: controller.visibleDeliveries,
        onRefresh: controller.loadDeliveries,
        onQueryChanged: controller.onQueryChanged,
        onOrderTap: controller.openDeliveryDetail,
        filterStatuses: controller.filterStatuses,
        isFilterSelected: controller.isFilterSelected,
        onFilterSelected: controller.selectFilter,
      ),
    );
  }
}
