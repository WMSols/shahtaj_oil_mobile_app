import 'package:geolocator/geolocator.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';

/// Shared GPS permission + position lookup for check-in and shop onboarding.
abstract class AppLocationHelper {
  AppLocationHelper._();

  /// Returns current position or throws [ApiException] with a user-facing message.
  static Future<Position> requireCurrentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw ApiException(message: AppTexts.obLocationDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw ApiException(message: AppTexts.obLocationPermissionDenied);
    }

    return Geolocator.getCurrentPosition();
  }
}
