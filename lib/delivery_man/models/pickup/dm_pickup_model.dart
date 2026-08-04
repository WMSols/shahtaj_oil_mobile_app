import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';

class DmPickupModel {
  const DmPickupModel({
    required this.id,
    required this.warehouseName,
    required this.vehicleCode,
    required this.shiftDate,
    required this.items,
    this.acknowledgedAt,
  });

  final String id;
  final String warehouseName;
  final String vehicleCode;
  final DateTime shiftDate;
  final List<DmStockItemModel> items;
  final DateTime? acknowledgedAt;

  bool get isAcknowledged => acknowledgedAt != null;

  int get totalLoadedUnits =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);

  DmPickupModel copyWith({
    String? id,
    String? warehouseName,
    String? vehicleCode,
    DateTime? shiftDate,
    List<DmStockItemModel>? items,
    DateTime? acknowledgedAt,
  }) => DmPickupModel(
    id: id ?? this.id,
    warehouseName: warehouseName ?? this.warehouseName,
    vehicleCode: vehicleCode ?? this.vehicleCode,
    shiftDate: shiftDate ?? this.shiftDate,
    items: items ?? this.items,
    acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
  );

  factory DmPickupModel.fromJson(Map<String, dynamic> json) => DmPickupModel(
    id: ApiMap.asString(json['id']) ?? '',
    warehouseName: ApiMap.asString(json['warehouse_name']) ?? '',
    vehicleCode: ApiMap.asString(json['vehicle_code']) ?? '',
    shiftDate: ApiMap.asDateTime(json['shift_date']) ?? DateTime.now(),
    items: ApiMap.asMapList(
      json['items'],
    ).map(DmStockItemModel.fromJson).toList(growable: false),
    acknowledgedAt: ApiMap.asDateTime(json['acknowledged_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'warehouse_name': warehouseName,
    'vehicle_code': vehicleCode,
    'shift_date': shiftDate.toIso8601String(),
    'acknowledged_at': acknowledgedAt?.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(growable: false),
  };
}
