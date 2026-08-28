import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_language_toggle.dart';

class AccountLanguageToggleSection extends StatelessWidget {
  const AccountLanguageToggleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();

    return Obx(
      () => AppLanguageToggle(
        isEnglishSelected:
            localeService.locale.value.languageCode ==
            LocaleService.english.languageCode,
        onEnglishPressed: localeService.setEnglish,
        onUrduPressed: localeService.setUrdu,
      ),
    );
  }
}
