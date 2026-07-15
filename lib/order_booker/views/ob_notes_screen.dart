import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/tasks/ob_notes_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_notes_controller.dart';

class ObNotesScreen extends GetView<ObNotesController> {
  const ObNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: controller.title,
      body: Obx(
        () => ObNotesContent(
          notesController: controller.notesController,
          hint: controller.hint,
          confirmLabel: controller.confirmLabel,
          isSaving: controller.isSaving.value,
          onSave: controller.save,
          onCancel: Get.back,
        ),
      ),
    );
  }
}
