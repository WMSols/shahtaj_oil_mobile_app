import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/bindings/initial_binding.dart';
import 'package:shahtaj_oil_mobile_app/core/design/system/app_system_ui.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/design/theme/app_theme.dart';
import 'package:shahtaj_oil_mobile_app/core/localization/app_translations.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_connectivity_banner.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_pages.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';

class ShahtajOilApp extends StatelessWidget {
  const ShahtajOilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppTexts.appName,
      theme: AppTheme.dark,
      translations: AppTranslations(),
      locale: Get.locale ?? LocaleService.english,
      fallbackLocale: LocaleService.english,
      supportedLocales: const [LocaleService.english, LocaleService.urdu],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final direction = Get.locale?.languageCode == 'ur'
            ? TextDirection.rtl
            : TextDirection.ltr;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppSystemUi.overlayStyle,
          child: Directionality(
            textDirection: direction,
            child: Stack(
              fit: StackFit.expand,
              children: [
                child ?? const SizedBox.shrink(),
                const AppToastHost(),
                const AppConnectivityBanner(),
              ],
            ),
          ),
        );
      },
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
