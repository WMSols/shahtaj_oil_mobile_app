import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmReturnLineModel {
  const DmReturnLineModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    this.reason,
  });

  final String productId;
  final String productName;
  final int quantity;
  final String? reason;

  DmReturnLineModel copyWith({
    String? productId,
    String? productName,
    int? quantity,
    String? reason,
  }) => DmReturnLineModel(
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    reason: reason ?? this.reason,
  );

  factory DmReturnLineModel.fromJson(Map<String, dynamic> json) =>
      DmReturnLineModel(
        productId:
            ApiMap.asString(json['product_id']) ??
            ApiMap.asString(json['id']) ??
            '',
        productName: ApiMap.asString(json['product_name']) ?? '',
        quantity: ApiMap.asInt(json['quantity']) ?? 0,
        reason: ApiMap.asString(json['reason']),
      );

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_name': productName,
    'quantity': quantity,
    'reason': reason,
  };
}

class DmReturnModel {
  const DmReturnModel({
    required this.id,
    required this.deliveryId,
    this.notes,
    this.leftover = const [],
    this.createdAt,
    this.submitted = false,
  });

  final String id;
  final String deliveryId;
  final String? notes;
  final List<DmReturnLineModel> leftover;
  final DateTime? createdAt;
  final bool submitted;

  DmReturnModel copyWith({
    String? id,
    String? deliveryId,
    String? notes,
    List<DmReturnLineModel>? leftover,
    DateTime? createdAt,
    bool? submitted,
  }) => DmReturnModel(
    id: id ?? this.id,
    deliveryId: deliveryId ?? this.deliveryId,
    notes: notes ?? this.notes,
    leftover: leftover ?? this.leftover,
    createdAt: createdAt ?? this.createdAt,
    submitted: submitted ?? this.submitted,
  );

  factory DmReturnModel.fromJson(Map<String, dynamic> json) {
    // Legacy caches may still have rejected/damaged — fold into leftover.
    final leftover = [
      ...ApiMap.asMapList(json['leftover']).map(DmReturnLineModel.fromJson),
      ...ApiMap.asMapList(json['rejected']).map(DmReturnLineModel.fromJson),
      ...ApiMap.asMapList(json['damaged']).map(DmReturnLineModel.fromJson),
    ];
    return DmReturnModel(
      id: ApiMap.asString(json['id']) ?? '',
      deliveryId: ApiMap.asString(json['delivery_id']) ?? '',
      notes: ApiMap.asString(json['notes']),
      leftover: leftover,
      createdAt: ApiMap.asDateTime(json['created_at']),
      submitted: json['submitted'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'delivery_id': deliveryId,
    'notes': notes,
    'leftover': leftover.map((e) => e.toJson()).toList(growable: false),
    'created_at': createdAt?.toUtc().toIso8601String(),
    'submitted': submitted,
  };
}
