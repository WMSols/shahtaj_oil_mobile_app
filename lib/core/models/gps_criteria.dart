import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

/// Server GPS gate (`gps_criteria` on login / plan or tasks today).
/// Values come from the API (or last offline save) — no app-hardcoded max.
class GpsCriteria {
  const GpsCriteria({required this.minM, required this.maxM});

  final double minM;
  final double maxM;

  factory GpsCriteria.fromJson(Map<String, dynamic> json) {
    final max = ApiMap.asDouble(json['max_m']);
    if (max == null || max <= 0) {
      throw FormatException('gps_criteria.max_m is required');
    }
    final min = ApiMap.asDouble(json['min_m']) ?? 0;
    return GpsCriteria(minM: min < 0 ? 0 : min, maxM: max);
  }

  static GpsCriteria? tryParse(dynamic raw) {
    final map = ApiMap.asMap(raw);
    if (map == null) return null;
    try {
      return GpsCriteria.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {'min_m': minM, 'max_m': maxM};
}
