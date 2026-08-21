import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_record_collection_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_record_collection_content.dart';

class DmRecordCollectionScreen extends GetView<DmRecordCollectionController> {
  const DmRecordCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmRecordCollectionTitle,
      body: const DmRecordCollectionContent(),
    );
  }
}
