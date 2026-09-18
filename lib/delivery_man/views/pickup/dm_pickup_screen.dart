import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/pickup/dm_pickup_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/pickup/dm_pickup_controller.dart';

class DmPickupScreen extends GetView<DmPickupController> {
  const DmPickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.load.value == null) {
          return const AppLoader();
        }
        return RefreshIndicator(
          onRefresh: () => controller.loadToday(force: true),
          child: const DmPickupContent(),
        );
      }),
    );
  }
}
