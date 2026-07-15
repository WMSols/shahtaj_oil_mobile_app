import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObTaskModel {
  const ObTaskModel({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.sequence,
    this.ownerName,
    this.phone,
    this.locationLabel,
    this.status = TaskStatus.pending,
    this.notes,
    this.shopLatitude,
    this.shopLongitude,
  });

  final int id;
  final String shopId;
  final String shopName;
  final String? ownerName;
  final String? phone;
  final String? locationLabel;
  final int sequence;
  final TaskStatus status;
  final String? notes;
  final double? shopLatitude;
  final double? shopLongitude;

  bool get hasShopCoordinates =>
      shopLatitude != null &&
      shopLongitude != null &&
      shopLatitude!.abs() <= 90 &&
      shopLongitude!.abs() <= 180;

  ObTaskModel copyWith({
    int? id,
    String? shopId,
    String? shopName,
    String? ownerName,
    String? phone,
    String? locationLabel,
    int? sequence,
    TaskStatus? status,
    String? notes,
    double? shopLatitude,
    double? shopLongitude,
  }) => ObTaskModel(
    id: id ?? this.id,
    shopId: shopId ?? this.shopId,
    shopName: shopName ?? this.shopName,
    ownerName: ownerName ?? this.ownerName,
    phone: phone ?? this.phone,
    locationLabel: locationLabel ?? this.locationLabel,
    sequence: sequence ?? this.sequence,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    shopLatitude: shopLatitude ?? this.shopLatitude,
    shopLongitude: shopLongitude ?? this.shopLongitude,
  );

  factory ObTaskModel.fromJson(Map<String, dynamic> json) {
    final shop = ApiMap.asMap(json['shop']) ?? const <String, dynamic>{};
    return ObTaskModel(
      id: ApiMap.asInt(json['task_id']) ?? ApiMap.asInt(json['id']) ?? 0,
      shopId:
          ApiMap.asString(json['shop_id']) ??
          ApiMap.asString(shop['shop_id']) ??
          ApiMap.asString(shop['id']) ??
          '',
      shopName:
          ApiMap.asString(json['shop_name']) ??
          ApiMap.asString(shop['name']) ??
          '',
      ownerName:
          ApiMap.asString(json['owner_name']) ??
          ApiMap.asString(shop['owner_name']),
      phone:
          ApiMap.asString(json['phone']) ??
          ApiMap.asString(shop['owner_phone']),
      locationLabel: ApiMap.asString(json['location_label']),
      sequence: ApiMap.asInt(json['sequence']) ?? 0,
      status: _parseStatus(json['status'] ?? json['state']),
      notes: ApiMap.asString(json['notes']),
      shopLatitude:
          ApiMap.asDouble(json['shop_latitude']) ??
          ApiMap.asDouble(shop['latitude']),
      shopLongitude:
          ApiMap.asDouble(json['shop_longitude']) ??
          ApiMap.asDouble(shop['longitude']),
    );
  }

  Map<String, dynamic> toJson() => {
    'task_id': id,
    'shop_id': shopId,
    'shop_name': shopName,
    'owner_name': ownerName,
    'phone': phone,
    'location_label': locationLabel,
    'sequence': sequence,
    'status': status.name,
    'notes': notes,
    'shop_latitude': shopLatitude,
    'shop_longitude': shopLongitude,
  };

  static TaskStatus _parseStatus(dynamic value) {
    final raw = value?.toString() ?? '';
    final normalized = ApiMap.snakeToCamel(raw);
    if (normalized == 'inProgress' || normalized == 'checkedIn') {
      return TaskStatus.inVisit;
    }
    return TaskStatus.values.firstWhere(
      (status) => status.name == raw || status.name == normalized,
      orElse: () => TaskStatus.pending,
    );
  }
}
