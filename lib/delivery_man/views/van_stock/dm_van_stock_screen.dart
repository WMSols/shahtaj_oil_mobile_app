import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/van_stock/dm_van_stock_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/van_stock/dm_van_stock_content.dart';

class DmVanStockScreen extends GetView<DmVanStockController> {
  const DmVanStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();
        return const DmVanStockContent();
      }),
    );
  }
}
