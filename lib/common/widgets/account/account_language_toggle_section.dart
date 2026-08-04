import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_language_toggle.dart';

class AccountLanguageToggleSection extends StatelessWidget {
  const AccountLanguageToggleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();

    return AppOutlineCard(
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.018),
      child: Obx(
        () => AppLanguageToggle(
          isEnglishSelected:
              localeService.locale.value.languageCode ==
              LocaleService.english.languageCode,
          onEnglishPressed: localeService.setEnglish,
          onUrduPressed: localeService.setUrdu,
        ),
      ),
    );
  }
}
