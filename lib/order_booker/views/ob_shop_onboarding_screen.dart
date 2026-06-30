import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shop_onboarding_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_module_placeholder.dart';

class ObShopOnboardingScreen extends GetView<ObShopOnboardingController> {
  const ObShopOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppModulePlaceholder(title: AppTexts.obShopOnboardingTitle);
  }
}
