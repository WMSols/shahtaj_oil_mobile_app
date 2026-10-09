import 'dart:async';
import 'dart:io' show Platform;

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

  /// Prefer a true GPS lock; reject coarse fused / network snaps.
  static const _targetAccuracyMeters = 50.0;

  /// Soft ceiling if we never hit the target during the sample window.
  static const _maxAcceptableAccuracyMeters = 80.0;

  /// How long to sample for a good high-accuracy fix.
  static const _sampleWindow = Duration(seconds: 25);

  /// Only accept last-known if it is essentially "just now" and accurate.
  static const _lastKnownMaxAge = Duration(seconds: 8);

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

  /// Ensures location service + permission, then returns a fresh high-accuracy
  /// position. Samples until accuracy is good enough (or the window ends).
  ///
  /// Does not prefer a medium/network fix — that caused urban check-ins to
  /// report points hundreds of meters away while Google Maps stayed on shop.
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
      try {
        return await _bestHighAccuracyPosition();
      } on ApiException {
        rethrow;
      } catch (e) {
        assert(() {
          // ignore: avoid_print
          print('requireCurrentPosition stream/oneshot failed: $e');
          return true;
        }());
      }

      final last = await Geolocator.getLastKnownPosition();
      if (last != null && _isFreshAccurate(last)) {
        return last;
      }

      throw ApiException(message: AppTexts.obLocationFetchFailed);
    } finally {
      AppToast.close();
    }
  }

  static bool _isFreshAccurate(Position position) {
    final age = DateTime.now().difference(position.timestamp);
    if (age.isNegative || age > _lastKnownMaxAge) return false;
    return _accuracyOk(position, _maxAcceptableAccuracyMeters);
  }

  static bool _accuracyOk(Position position, double maxMeters) {
    final accuracy = position.accuracy;
    // Some platforms report 0 for unknown; treat as not proven accurate.
    if (accuracy <= 0) return false;
    return accuracy <= maxMeters;
  }

  static LocationSettings _highAccuracySettings({Duration? timeLimit}) {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
        forceLocationManager: false,
        intervalDuration: const Duration(seconds: 1),
        timeLimit: timeLimit,
      );
    }
    if (Platform.isIOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.other,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: false,
        timeLimit: timeLimit,
      );
    }
    return LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
      timeLimit: timeLimit,
    );
  }

  /// Sample high-accuracy fixes and return as soon as accuracy is good.
  static Future<Position> _bestHighAccuracyPosition() async {
    Position? best;
    final done = Completer<Position>();
    StreamSubscription<Position>? subscription;
    Timer? timer;

    void consider(Position position) {
      if (best == null ||
          (position.accuracy > 0 &&
              (best!.accuracy <= 0 || position.accuracy < best!.accuracy))) {
        best = position;
      }
      if (!done.isCompleted && _accuracyOk(position, _targetAccuracyMeters)) {
        done.complete(position);
      }
    }

    timer = Timer(_sampleWindow, () {
      if (done.isCompleted) return;
      final candidate = best;
      if (candidate != null &&
          _accuracyOk(candidate, _maxAcceptableAccuracyMeters)) {
        done.complete(candidate);
        return;
      }
      done.completeError(ApiException(message: AppTexts.obLocationFetchFailed));
    });

    try {
      subscription =
          Geolocator.getPositionStream(
            locationSettings: _highAccuracySettings(),
          ).listen(
            consider,
            onError: (Object e) {
              if (!done.isCompleted && best == null) {
                done.completeError(e);
              }
            },
            cancelOnError: false,
          );

      // Kick a one-shot in parallel — some devices are slow to start the stream.
      unawaited(() async {
        try {
          final oneShot = await Geolocator.getCurrentPosition(
            locationSettings: _highAccuracySettings(timeLimit: _sampleWindow),
          );
          consider(oneShot);
        } catch (_) {
          // Stream / timer still drive completion.
        }
      }());

      return await done.future;
    } finally {
      timer.cancel();
      await subscription?.cancel();
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
