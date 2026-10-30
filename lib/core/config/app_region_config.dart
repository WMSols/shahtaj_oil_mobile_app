import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

/// Build-time region for the installed flavor (ISB / MRE).
///
/// Pass `--dart-define=FLAVOR=isb|mre` so the matching `.env.*` file loads.
/// Display names live in [AppTexts], not in env files.
abstract class AppRegionConfig {
  AppRegionConfig._();

  static const String flavorIsb = 'isb';
  static const String flavorMre = 'mre';

  /// Compile-time flavor; defaults to ISB for local runs without defines.
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: flavorIsb,
  );

  static String get envFileName => '.env.$flavor';

  /// From dotenv `REGION_CODE`, falling back to [flavor].
  static String get regionCode {
    final fromEnv = dotenv.env['REGION_CODE']?.trim().toLowerCase();
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    return flavor;
  }

  static bool get isIsb => regionCode == flavorIsb;
  static bool get isMre => regionCode == flavorMre;

  /// Localized region label for Auth / Onboarding / Account.
  static String get regionDisplayName {
    switch (regionCode) {
      case flavorMre:
        return AppTexts.regionMurree;
      case flavorIsb:
      default:
        return AppTexts.regionIsb;
    }
  }
}
