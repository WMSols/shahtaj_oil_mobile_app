import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObWeeklyScheduleDayModel {
  const ObWeeklyScheduleDayModel({
    required this.weekday,
    required this.label,
    this.routeId,
    this.routeName,
    this.zoneId,
    this.zoneName,
    this.shopCount = 0,
    this.distanceKm = 0,
    this.isOffDay = false,
  });

  final int weekday;
  final String label;
  final int? routeId;
  final String? routeName;
  final int? zoneId;
  final String? zoneName;
  final int shopCount;
  final double distanceKm;
  final bool isOffDay;

  bool get hasAssignment => !isOffDay && routeId != null;

  factory ObWeeklyScheduleDayModel.fromJson(Map<String, dynamic> json) {
    final route = ApiMap.asMap(json['route']) ?? const <String, dynamic>{};
    final zone = ApiMap.asMap(json['zone']) ?? const <String, dynamic>{};
    final rawWeekday =
        ApiMap.asInt(json['weekday']) ?? ApiMap.asInt(json['day_of_week']);
    // Odoo day_of_week is 0=Monday … 6=Sunday; Dart DateTime uses 1=Monday … 7=Sunday.
    final weekday = rawWeekday == null
        ? DateTime.monday
        : (rawWeekday >= 0 && rawWeekday <= 6 ? rawWeekday + 1 : rawWeekday);

    return ObWeeklyScheduleDayModel(
      weekday: weekday,
      label:
          ApiMap.asString(json['label']) ??
          ApiMap.asString(json['day_label']) ??
          '',
      routeId: ApiMap.asInt(json['route_id']) ?? ApiMap.asInt(route['id']),
      routeName:
          ApiMap.asString(json['route_name']) ?? ApiMap.asString(route['name']),
      zoneId: ApiMap.asInt(json['zone_id']) ?? ApiMap.asInt(zone['id']),
      zoneName:
          ApiMap.asString(json['zone_name']) ?? ApiMap.asString(zone['name']),
      shopCount: ApiMap.asInt(json['shop_count']) ?? 0,
      distanceKm: ApiMap.asDouble(json['distance_km']) ?? 0,
      isOffDay: json['is_off_day'] as bool? ?? false,
    );
  }
}

class ObWeeklyScheduleModel {
  const ObWeeklyScheduleModel({required this.days});

  final List<ObWeeklyScheduleDayModel> days;

  factory ObWeeklyScheduleModel.fromJson(Map<String, dynamic> json) {
    final list = json.containsKey('schedules')
        ? ApiMap.listOf(json, 'schedules')
        : ApiMap.listOf(json, 'days');
    final days = list
        .map(ObWeeklyScheduleDayModel.fromJson)
        .toList(growable: false);
    days.sort((a, b) => a.weekday.compareTo(b.weekday));
    return ObWeeklyScheduleModel(days: days);
  }
}
