import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObRouteOption {
  const ObRouteOption({
    required this.id,
    required this.zoneId,
    required this.name,
  });

  final int id;
  final int zoneId;
  final String name;

  factory ObRouteOption.fromJson(Map<String, dynamic> json) {
    return ObRouteOption(
      id: ApiMap.asInt(json['id']) ?? 0,
      zoneId:
          ApiMap.asInt(json['zone_id']) ??
          ApiMap.asInt(ApiMap.asMap(json['zone'])?['id']) ??
          0,
      name: ApiMap.asString(json['name']) ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObRouteOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
