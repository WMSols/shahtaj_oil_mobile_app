import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/deliveries/dm_deliveries_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/deliveries/dm_deliveries_controller.dart';

class DmDeliveriesScreen extends GetView<DmDeliveriesController> {
  const DmDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return AppShimmerSkeletons.genericList(context);
        }
        return const DmDeliveriesContent();
      }),
    );
  }
}
