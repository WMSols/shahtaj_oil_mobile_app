import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_fab_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/shops/my_shops/ob_my_shops_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_my_shops_controller.dart';

class ObMyShopsScreen extends GetView<ObMyShopsController> {
  const ObMyShopsScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    final fab = AppFABButton(
      label: AppTexts.obShopOnboardingTitle,
      icon: AppIcons.addshop,
      onPressed: () =>
          controller.goToRegisterShop(embeddedInShell: embeddedInShell),
    );

    const content = ObMyShopsContent();

    if (embeddedInShell) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        floatingActionButton: fab,
        body: content,
      );
    }

    return AppSubScreenScaffold(
      title: AppTexts.obRegisteredShopsTitle,
      floatingActionButton: fab,
      body: content,
    );
  }
}
