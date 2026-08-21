import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/handover/dm_handover_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/handover/dm_handover_detail_content.dart';

class DmHandoverDetailScreen extends GetView<DmHandoverDetailController> {
  const DmHandoverDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmHandoverDetailTitle,
      body: const DmHandoverDetailContent(),
    );
  }
}
