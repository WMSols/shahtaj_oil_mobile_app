import 'package:shahtaj_oil_mobile_app/core/config/app_region_config.dart';

/// Per-region feature switches for ISB / MRE builds.
///
/// Identity (flavor, labels) lives in [AppRegionConfig].
/// Capabilities live here. Gate shell tabs, routes, and bindings with these
/// flags when a region should hide or drop a feature — not deep in every widget.
///
/// Defaults keep both apps identical (`isb: true`, `mre: true`). Flip a side
/// to `false` when that region should omit the feature, then wire the flag at
/// the edge (nav / route / binding).
abstract class AppRegionFeatures {
  AppRegionFeatures._();

  // --- Placeholders: rename/add when a real split appears; leave unused for now ---

  static bool get exampleFeatureA => _enabled(isb: true, mre: true);

  static bool get exampleFeatureB => _enabled(isb: true, mre: true);

  static bool _enabled({required bool isb, required bool mre}) {
    if (AppRegionConfig.isMre) return mre;
    return isb;
  }
}
