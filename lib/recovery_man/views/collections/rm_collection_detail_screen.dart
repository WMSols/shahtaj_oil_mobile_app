import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_collection_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/collections/rm_collection_detail_content.dart';

class RmCollectionDetailScreen extends GetView<RmCollectionDetailController> {
  const RmCollectionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.rmCollectionDetailTitle,
      body: const RmCollectionDetailContent(),
    );
  }
}
