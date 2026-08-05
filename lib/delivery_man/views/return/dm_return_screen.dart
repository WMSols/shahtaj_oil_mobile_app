import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/return/dm_return_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/return/dm_return_controller.dart';

class DmReturnScreen extends GetView<DmReturnController> {
  const DmReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();
        return const DmReturnContent();
      }),
    );
  }
}
