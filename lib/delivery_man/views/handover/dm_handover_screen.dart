import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/handover/dm_handover_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/handover/dm_handover_content.dart';

class DmHandoverScreen extends GetView<DmHandoverController> {
  const DmHandoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: ColoredBox(
        color: AppColors.scaffoldBackground,
        child: DmHandoverContent(),
      ),
    );
  }
}
