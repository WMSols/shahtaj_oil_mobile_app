import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

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
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    description: json['description']?.toString(),
    shopCount: (json['shop_count'] as num?)?.toInt() ?? 0,
    distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0,
    status: RouteStatus.values.firstWhere(
      (s) => s.name == json['status']?.toString(),
      orElse: () => RouteStatus.notStarted,
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'shop_count': shopCount,
    'distance_km': distanceKm,
    'status': status.name,
  };
}
