import 'package:geolocator/geolocator.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_location_enable_sheet.dart';

class AppHelper {
  AppHelper._();

  static DateTime? parseDateTimeOrNull(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final s = value.trim();
    final fromApi = ApiMap.asDateTime(s);
    if (fromApi != null) return fromApi;
    final parts = s.split('-');
    if (parts.length >= 3) {
      final y = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final d = int.tryParse(parts[2].split('T').first.split(' ').first);
      if (y != null && m != null && d != null) {
        return DateTime(y, m, d);
      }
    }
    return null;
  }

  static bool isNullOrEmpty(String? value) =>
      value == null || value.trim().isEmpty;

  static bool isNotNullOrEmpty(String? value) => !isNullOrEmpty(value);

  static List<String> parseCommaSeparatedList(String? value) {
    if (value == null || value.trim().isEmpty) return const [];
    return value
        .trim()
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Returns up to two uppercase initials from [name].
  /// Example: "Mubeen Bhatti" → "MB", "Ali" → "A".
  static String initialsFromName(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final word = parts.first;
      return word.length == 1
          ? word.toUpperCase()
          : word.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  static String truncateText(String text, {int maxLength = 80}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…';
  }

  static const _positionTimeout = Duration(seconds: 10);
  static const _lastKnownMaxAge = Duration(minutes: 2);

  /// Client gate for place-order; keep aligned with backend geofence when known.
  static const placeOrderMaxDistanceMeters = 250.0;

  /// Straight-line distance in meters between two WGS84 points.
  static double distanceMetersBetween({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) => Geolocator.distanceBetween(fromLat, fromLng, toLat, toLng);

  /// Throws when the booker is farther than [placeOrderMaxDistanceMeters]
  /// from the shop, so we never queue an order the server would reject.
  static void ensureWithinPlaceOrderRange({
    required double currentLat,
    required double currentLng,
    required double shopLat,
    required double shopLng,
  }) {
    final meters = distanceMetersBetween(
      fromLat: currentLat,
      fromLng: currentLng,
      toLat: shopLat,
      toLng: shopLng,
    );
    if (meters > placeOrderMaxDistanceMeters) {
      throw ApiException(
        message: AppTexts.obOrderTooFarFromShop(meters.round()),
      );
    }
  }

  /// Ensures location service + permission, then returns current position.
  ///
  /// Uses a hard [timeLimit] so callers (e.g. check-in) cannot hang forever on
  /// weak GPS / network-assisted location. Falls back to a recent last-known
  /// fix when a fresh fix times out.
  ///
  /// When [showGuide] is true, opens a bottom sheet to enable location /
  /// permission on the device instead of only throwing.
  static Future<Position> requireCurrentPosition({
    bool showGuide = true,
  }) async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      if (showGuide) {
        await AppLocationEnableSheet.show(AppLocationGuideKind.serviceDisabled);
      }
      throw ApiException(message: AppTexts.obLocationDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (showGuide) {
        await AppLocationEnableSheet.show(
          AppLocationGuideKind.permissionDenied,
        );
      }
      throw ApiException(message: AppTexts.obLocationPermissionDenied);
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: _positionTimeout,
        ),
      );
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        final age = DateTime.now().difference(last.timestamp);
        if (!age.isNegative && age <= _lastKnownMaxAge) {
          return last;
        }
      }
      throw ApiException(message: AppTexts.obLocationFetchFailed);
    }
  }
}
