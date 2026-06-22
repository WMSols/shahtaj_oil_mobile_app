import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dm_deliveries_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_module_placeholder.dart';

class DmDeliveriesScreen extends GetView<DmDeliveriesController> {
  const DmDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppModulePlaceholder(title: AppTexts.navDeliveries);
  }
}