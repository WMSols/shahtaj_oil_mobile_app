import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/handover/rm_handover_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/handover/rm_handover_detail_content.dart';

class RmHandoverDetailScreen extends GetView<RmHandoverDetailController> {
  const RmHandoverDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.rmHandoverDetailTitle,
      body: const RmHandoverDetailContent(),
    );
  }
}
