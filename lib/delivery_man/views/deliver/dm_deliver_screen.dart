import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/deliver/dm_deliver_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/deliver/dm_deliver_controller.dart';

class DmDeliverScreen extends GetView<DmDeliverController> {
  const DmDeliverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();
        return const DmDeliverContent();
      }),
    );
  }
}
