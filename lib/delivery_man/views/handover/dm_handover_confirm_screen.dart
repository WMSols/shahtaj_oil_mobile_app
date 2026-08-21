import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/handover/dm_handover_confirm_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/handover/dm_handover_confirm_content.dart';

class DmHandoverConfirmScreen extends GetView<DmHandoverConfirmController> {
  const DmHandoverConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmHandoverConfirmTitle,
      body: const DmHandoverConfirmContent(),
    );
  }
}
