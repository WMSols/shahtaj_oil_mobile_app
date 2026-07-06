import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

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

  factory ObTaskModel.fromJson(Map<String, dynamic> json) => ObTaskModel(
    id:
        (json['task_id'] as num?)?.toInt() ??
        (json['id'] as num?)?.toInt() ??
        0,
    shopId: json['shop_id']?.toString() ?? '',
    shopName: json['shop_name']?.toString() ?? '',
    ownerName: json['owner_name']?.toString(),
    phone: json['phone']?.toString(),
    locationLabel: json['location_label']?.toString(),
    sequence: (json['sequence'] as num?)?.toInt() ?? 0,
    status: _parseStatus(json['status']),
    notes: json['notes']?.toString(),
    shopLatitude: (json['shop_latitude'] as num?)?.toDouble(),
    shopLongitude: (json['shop_longitude'] as num?)?.toDouble(),
  );

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
    return TaskStatus.values.firstWhere(
      (status) => status.name == raw || status.name == _snakeToCamel(raw),
      orElse: () => TaskStatus.pending,
    );
  }

  static String _snakeToCamel(String value) {
    if (!value.contains('_')) return value;
    final parts = value.split('_');
    return parts.first +
        parts.skip(1).map((part) {
          if (part.isEmpty) return '';
          return part[0].toUpperCase() + part.substring(1);
        }).join();
  }
}
