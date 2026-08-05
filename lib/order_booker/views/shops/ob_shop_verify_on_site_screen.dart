import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/shops/verify/ob_shop_verify_on_site_content.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_loader.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/shops/ob_shop_verify_on_site_controller.dart';

class ObShopVerifyOnSiteScreen extends GetView<ObShopVerifyOnSiteController> {
  const ObShopVerifyOnSiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.obCheckInTitle,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoader();
        }

        final task = controller.task.value;
        if (task == null) {
          return AppEmptyState(
            title: AppTexts.emptyNotFoundTitle,
            subtitle: AppTexts.obTaskNotFound,
            image: AppImages.emptyNotFound,
          );
        }

        return ObShopVerifyOnSiteContent(controller: controller, task: task);
      }),
    );
  }
}
