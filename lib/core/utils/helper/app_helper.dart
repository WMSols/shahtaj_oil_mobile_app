import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
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

  /// Live max from session (`gps_criteria.max_m` saved at login / today tasks).
  /// Throws when criteria was never received (cannot invent a distance).
  static double resolvedShopMaxDistanceMeters() {
    if (!Get.isRegistered<SessionService>()) {
      throw ApiException(message: AppTexts.obGpsCriteriaMissing);
    }
    final max = Get.find<SessionService>().shopActionMaxDistanceMeters;
    if (max == null || max <= 0) {
      throw ApiException(message: AppTexts.obGpsCriteriaMissing);
    }
    return max;
  }

  /// Straight-line distance in meters between two WGS84 points.
  static double distanceMetersBetween({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) => Geolocator.distanceBetween(fromLat, fromLng, toLat, toLng);

  /// Blocks when the shop has no usable coords, or the user is too far away.
  static void ensureWithinShopRange({
    required double currentLat,
    required double currentLng,
    double? shopLat,
    double? shopLng,
    double? maxMeters,
  }) {
    final hasShop =
        shopLat != null &&
        shopLng != null &&
        shopLat.abs() <= 90 &&
        shopLng.abs() <= 180 &&
        !(shopLat == 0 && shopLng == 0);
    if (!hasShop) {
      throw ApiException(message: AppTexts.obShopLocationMissing);
    }
    final limit = maxMeters ?? resolvedShopMaxDistanceMeters();
    final meters = distanceMetersBetween(
      fromLat: currentLat,
      fromLng: currentLng,
      toLat: shopLat,
      toLng: shopLng,
    );
    if (meters > limit) {
      throw ApiException(
        message: AppTexts.obOrderTooFarFromShop(
          meters.round(),
          maxMeters: limit.round(),
        ),
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
