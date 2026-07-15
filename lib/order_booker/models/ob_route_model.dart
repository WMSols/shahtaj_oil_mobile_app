import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObRouteModel {
  const ObRouteModel({
    required this.id,
    required this.name,
    this.description,
    this.shopCount = 0,
    this.distanceKm = 0,
    this.status = RouteStatus.notStarted,
  });

  final String id;
  final String name;
  final String? description;
  final int shopCount;
  final double distanceKm;
  final RouteStatus status;

  factory ObRouteModel.fromJson(Map<String, dynamic> json) => ObRouteModel(
    id: ApiMap.asString(json['id']) ?? '',
    name: ApiMap.asString(json['name']) ?? '',
    description: ApiMap.asString(json['description']),
    shopCount: ApiMap.asInt(json['shop_count']) ?? 0,
    distanceKm: ApiMap.asDouble(json['distance_km']) ?? 0,
    status: parseStatus(json['status']),
  );

  static RouteStatus parseStatus(dynamic value) {
    final raw = value?.toString() ?? '';
    final normalized = ApiMap.snakeToCamel(raw);
    return RouteStatus.values.firstWhere(
      (status) => status.name == raw || status.name == normalized,
      orElse: () => RouteStatus.notStarted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'shop_count': shopCount,
    'distance_km': distanceKm,
    'status': status.name,
  };
}
