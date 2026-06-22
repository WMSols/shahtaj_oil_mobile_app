import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/bindings/initial_binding.dart';
import 'package:shahtaj_oil_mobile_app/core/design/system/app_system_ui.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/design/theme/app_theme.dart';
import 'package:shahtaj_oil_mobile_app/core/localization/app_translations.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_pages.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_animated_directionality.dart';

class ShahtajOilApp extends StatelessWidget {
  const ShahtajOilApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();

    return Obx(() {
      final locale = localeService.locale.value;
      final direction = locale.languageCode == 'ur'
          ? TextDirection.rtl
          : TextDirection.ltr;

      return GetMaterialApp(
        title: AppTexts.appName,
        theme: AppTheme.dark,
        translations: AppTranslations(),
        locale: locale,
        fallbackLocale: LocaleService.english,
        supportedLocales: const [
          LocaleService.english,
          LocaleService.urdu,
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppSystemUi.overlayStyle,
            child: AppAnimatedDirectionality(
              textDirection: direction,
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
        initialBinding: InitialBinding(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
