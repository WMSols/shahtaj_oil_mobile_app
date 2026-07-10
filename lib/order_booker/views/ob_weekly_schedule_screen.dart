import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/schedule/ob_weekly_schedule_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_weekly_schedule_controller.dart';

class ObWeeklyScheduleScreen extends GetView<ObWeeklyScheduleController> {
  const ObWeeklyScheduleScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    const content = ObWeeklyScheduleContent();
    if (embeddedInShell) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: content,
      );
    }
    return AppSubScreenScaffold(
      title: AppTexts.navWeeklySchedule,
      body: content,
    );
  }
}
