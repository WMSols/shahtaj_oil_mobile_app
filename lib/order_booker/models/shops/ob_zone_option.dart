import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObZoneOption {
  const ObZoneOption({required this.id, required this.name});

  final int id;
  final String name;

  factory ObZoneOption.fromJson(Map<String, dynamic> json) {
    return ObZoneOption(
      id: ApiMap.asInt(json['id']) ?? 0,
      name: ApiMap.asString(json['name']) ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObZoneOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
