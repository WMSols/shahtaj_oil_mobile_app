import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_today_shops_content.dart';

class DmTodayShopsScreen extends GetView<DmTodayShopsController> {
  const DmTodayShopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: ColoredBox(
        color: AppColors.scaffoldBackground,
        child: DmTodayShopsContent(),
      ),
    );
  }
}
