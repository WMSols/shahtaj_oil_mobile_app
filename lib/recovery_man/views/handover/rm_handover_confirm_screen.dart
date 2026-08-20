import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/handover/rm_handover_confirm_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/handover/rm_handover_confirm_content.dart';

class RmHandoverConfirmScreen extends GetView<RmHandoverConfirmController> {
  const RmHandoverConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.rmHandoverConfirmTitle,
      body: const RmHandoverConfirmContent(),
    );
  }
}
