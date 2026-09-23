import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_location_enable_sheet.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

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

  /// Prefer a fresh fix after location was just toggled on.
  static const _positionTimeout = Duration(seconds: 8);
  static const _positionAttempts = 3;

  /// Only accept last-known if it is essentially "just now" (not minutes old).
  static const _lastKnownMaxAge = Duration(seconds: 30);

  /// Live max from session (`gps_criteria.max_m` saved at login / plan / today).
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

  /// True when [shopLat]/[shopLng] are usable WGS84 (not null / 0,0 / out of range).
  static bool hasUsableShopCoordinates(double? shopLat, double? shopLng) =>
      shopLat != null &&
      shopLng != null &&
      shopLat.abs() <= 90 &&
      shopLng.abs() <= 180 &&
      !(shopLat == 0 && shopLng == 0);

  /// Distance vs session max. Throws only when the shop has no usable pin.
  static ShopRangeEvaluation evaluateShopRange({
    required double currentLat,
    required double currentLng,
    double? shopLat,
    double? shopLng,
    double? maxMeters,
  }) {
    if (!hasUsableShopCoordinates(shopLat, shopLng)) {
      throw ApiException(message: AppTexts.obShopLocationMissing);
    }
    final limit = maxMeters ?? resolvedShopMaxDistanceMeters();
    final meters = distanceMetersBetween(
      fromLat: currentLat,
      fromLng: currentLng,
      toLat: shopLat!,
      toLng: shopLng!,
    );
    return ShopRangeEvaluation(
      meters: meters,
      limit: limit,
      outOfRange: meters > limit,
    );
  }

  /// Blocks when the shop has no usable coords, or the user is too far away.
  static void ensureWithinShopRange({
    required double currentLat,
    required double currentLng,
    double? shopLat,
    double? shopLng,
    double? maxMeters,
  }) {
    final evaluation = evaluateShopRange(
      currentLat: currentLat,
      currentLng: currentLng,
      shopLat: shopLat,
      shopLng: shopLng,
      maxMeters: maxMeters,
    );
    if (evaluation.outOfRange) {
      throw ApiException(
        message: AppTexts.obOrderTooFarFromShop(
          evaluation.meters.round(),
          maxMeters: evaluation.limit.round(),
        ),
      );
    }
  }

  /// Extra GPS fields for check-in (online + outbox) so the panel can show distance.
  /// Does not include latitude/longitude — callers send those separately.
  static Map<String, dynamic> checkInGpsExtras({
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    double? shopLat,
    double? shopLng,
    DateTime? capturedAt,
  }) {
    final payload = <String, dynamic>{
      'gps_accuracy_m': accuracyMeters,
      'captured_at': (capturedAt ?? DateTime.now()).toUtc().toIso8601String(),
    };
    if (!hasUsableShopCoordinates(shopLat, shopLng)) return payload;
    final evaluation = evaluateShopRange(
      currentLat: latitude,
      currentLng: longitude,
      shopLat: shopLat,
      shopLng: shopLng,
    );
    payload['distance_m'] = evaluation.meters.round();
    payload['out_of_range'] = evaluation.outOfRange;
    payload['gps_max_m'] = evaluation.limit.round();
    return payload;
  }

  /// Ensures location service + permission, then returns a fresh position.
  ///
  /// Retries briefly after location was just toggled on. Does not use a
  /// long-lived last-known fix — place-order / check-in need the spot now.
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

    AppToast.showInformation(
      AppTexts.obGettingGpsLocation,
      duration: const Duration(seconds: 45),
    );
    try {
      Object? lastError;
      for (var attempt = 0; attempt < _positionAttempts; attempt++) {
        if (attempt > 0) {
          await Future<void>.delayed(Duration(milliseconds: 400 * attempt));
        }
        try {
          return await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(
              accuracy: attempt == 0
                  ? LocationAccuracy.medium
                  : LocationAccuracy.high,
              timeLimit: _positionTimeout,
            ),
          );
        } catch (e) {
          lastError = e;
        }
      }

      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        final age = DateTime.now().difference(last.timestamp);
        if (!age.isNegative && age <= _lastKnownMaxAge) {
          return last;
        }
      }

      assert(() {
        // ignore: avoid_print
        print('requireCurrentPosition failed after retries: $lastError');
        return true;
      }());
      throw ApiException(message: AppTexts.obLocationFetchFailed);
    } finally {
      AppToast.close();
    }
  }
}

/// Result of comparing the OB's GPS fix against the shop pin and session max.
class ShopRangeEvaluation {
  const ShopRangeEvaluation({
    required this.meters,
    required this.limit,
    required this.outOfRange,
  });

  final double meters;
  final double limit;
  final bool outOfRange;
}
