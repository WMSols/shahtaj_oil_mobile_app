import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/splash_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();
    final logoWidth = AppResponsive.screenWidth(context) * 0.55;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Obx(
          () => Image.asset(
            localeService.isRtl
                ? AppImages.appLogoUrdu
                : AppImages.appLogoEnglish,
            width: logoWidth,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
