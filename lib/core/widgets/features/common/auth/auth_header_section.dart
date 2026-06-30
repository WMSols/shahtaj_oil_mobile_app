import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/auth_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';

class AuthHeaderSection extends GetView<AuthController> {
  const AuthHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();
    final logoWidth = AppResponsive.screenWidth(context) * 0.45;

    return Padding(
      padding: AppSpacing.screenPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
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
          AppSpacing.vertical(context, 0.04),
          RichText(
            text: TextSpan(
              style: AppTextStyles.heading(context),
              children: [
                TextSpan(text: AppTexts.signIn),
                TextSpan(
                  text: ' ${AppTexts.signingInAs}\n',
                  style: AppTextStyles.bodyText(context),
                ),
                TextSpan(
                  text: '“${controller.role.label}”',
                  style: AppTextStyles.headline(context),
                ),
              ],
            ),
          ),
          AppSpacing.vertical(context, 0.005),
          Text(
            AppTexts.authWelcomeSubtitle,
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
