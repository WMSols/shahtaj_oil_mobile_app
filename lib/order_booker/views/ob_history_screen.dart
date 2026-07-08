import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/history/ob_visit_history_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_history_controller.dart';

class ObHistoryScreen extends GetView<ObHistoryController> {
  const ObHistoryScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    const content = ObVisitHistoryContent();

    if (embeddedInShell) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: content,
      );
    }

    return AppSubScreenScaffold(title: AppTexts.navHistory, body: content);
  }
}
