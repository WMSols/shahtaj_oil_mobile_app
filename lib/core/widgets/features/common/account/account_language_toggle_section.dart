import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';

class AccountLanguageToggleSection extends StatelessWidget {
  const AccountLanguageToggleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();

    return AppOutlineCard(
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.018),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: AppSecondaryButton(
                label: AppTexts.languageEnglishButton,
                labelStyle: AppTextStyles.languagePickerButtonText(
                  context,
                  urdu: false,
                ),
                onPressed: localeService.locale.value == LocaleService.english
                    ? null
                    : localeService.setEnglish,
              ),
            ),
            AppSpacing.horizontal(context, 0.02),
            Expanded(
              child: AppSecondaryButton(
                label: AppTexts.languageUrduButton,
                labelStyle: AppTextStyles.languagePickerButtonText(
                  context,
                  urdu: true,
                ),
                onPressed: localeService.locale.value == LocaleService.urdu
                    ? null
                    : localeService.setUrdu,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
