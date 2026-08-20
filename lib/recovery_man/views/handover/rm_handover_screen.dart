import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/handover/rm_handover_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/handover/rm_handover_content.dart';

class RmHandoverScreen extends GetView<RmHandoverController> {
  const RmHandoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: ColoredBox(
        color: AppColors.scaffoldBackground,
        child: RmHandoverContent(),
      ),
    );
  }
}
