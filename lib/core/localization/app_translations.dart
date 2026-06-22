import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/localization/app_translation_maps.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': AppTranslationMaps.en,
    'ur_PK': AppTranslationMaps.ur,
  };
}
