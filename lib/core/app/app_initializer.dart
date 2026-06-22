import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/system/app_system_ui.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> setup() async {
    await AppSystemUi.apply();
    await dotenv.load(fileName: '.env');

    final storage = StorageService();
    Get.put(storage, permanent: true);

    final localeService = LocaleService(storage);
    await localeService.init();
    Get.put(localeService, permanent: true);

    final sessionService = SessionService(storage);
    await sessionService.init();
    Get.put(sessionService, permanent: true);
  }
}
