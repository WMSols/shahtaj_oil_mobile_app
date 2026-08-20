import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/collections/rm_today_shops_content.dart';

class RmTodayShopsScreen extends GetView<RmTodayShopsController> {
  const RmTodayShopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: ColoredBox(
        color: AppColors.scaffoldBackground,
        child: RmTodayShopsContent(),
      ),
    );
  }
}
