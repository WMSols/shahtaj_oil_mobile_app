import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/account_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();

    return AppScaffold(
      body: Padding(
        padding: AppSpacing.screenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppTexts.myProfile, style: AppTextStyles.headline(context)),
            AppSpacing.vertical(context, 0.02),
            Text(controller.userName, style: AppTextStyles.bodyText(context)),
            Text(controller.userEmail, style: AppTextStyles.hintText(context)),
            AppSpacing.vertical(context, 0.03),
            Text(
              AppTexts.changeLanguage,
              style: AppTextStyles.sectionTitle(context),
            ),
            AppSpacing.vertical(context, 0.01),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: AppSecondaryButton(
                      label: AppTexts.languageEnglish,
                      onPressed:
                          localeService.locale.value == LocaleService.english
                          ? null
                          : localeService.setEnglish,
                    ),
                  ),
                  AppSpacing.horizontal(context, 0.02),
                  Expanded(
                    child: AppSecondaryButton(
                      label: AppTexts.languageUrdu,
                      onPressed:
                          localeService.locale.value == LocaleService.urdu
                          ? null
                          : localeService.setUrdu,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Obx(
              () => AppPrimaryButton(
                label: AppTexts.logout,
                isLoading: controller.isLoggingOut.value,
                onPressed: controller.logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
