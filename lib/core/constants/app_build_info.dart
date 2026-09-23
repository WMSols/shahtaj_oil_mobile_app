/// Manual release / QA build stamp shown as a badge in the app chrome.
///
/// Bump [buildNumber] by hand before each build you want testers to identify
/// (e.g. 8 → 9). Label renders as `V8`, `V9`, …
abstract class AppBuildInfo {
  AppBuildInfo._();

  /// Change this integer when cutting a build for QA / field.
  static const int buildNumber = 8;

  static String get versionLabel => 'V$buildNumber';
}
