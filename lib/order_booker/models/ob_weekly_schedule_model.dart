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

  factory ObWeeklyScheduleDayModel.fromJson(Map<String, dynamic> json) =>
      ObWeeklyScheduleDayModel(
        weekday: (json['weekday'] as num?)?.toInt() ?? 1,
        label: json['label']?.toString() ?? '',
        routeId: (json['route_id'] as num?)?.toInt(),
        routeName: json['route_name']?.toString(),
        zoneId: (json['zone_id'] as num?)?.toInt(),
        zoneName: json['zone_name']?.toString(),
        shopCount: (json['shop_count'] as num?)?.toInt() ?? 0,
        distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0,
        isOffDay: json['is_off_day'] as bool? ?? false,
      );
}

class ObWeeklyScheduleModel {
  const ObWeeklyScheduleModel({required this.days});

  final List<ObWeeklyScheduleDayModel> days;

  factory ObWeeklyScheduleModel.fromJson(Map<String, dynamic> json) {
    final list = json['days'] as List<dynamic>? ?? const [];
    return ObWeeklyScheduleModel(
      days: list
          .map(
            (item) =>
                ObWeeklyScheduleDayModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
