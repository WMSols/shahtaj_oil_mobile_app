import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_record_collection_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/collections/rm_record_collection_content.dart';

class RmRecordCollectionScreen extends GetView<RmRecordCollectionController> {
  const RmRecordCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.rmRecordCollectionTitle,
      body: const RmRecordCollectionContent(),
    );
  }
}
