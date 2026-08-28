import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van_stock/dm_van_stock_document_model.dart';

/// Today's van inventory for editable whole-list load / unload.
class DmVanStockModel {
  const DmVanStockModel({
    required this.id,
    required this.warehouseName,
    required this.vehicleCode,
    required this.shiftDate,
    required this.items,
    this.loadedAt,
    this.unloadedAt,
    this.notes = '',
    this.history = const [],
  });

  final String id;
  final String warehouseName;
  final String vehicleCode;
  final DateTime shiftDate;
  final List<DmStockItemModel> items;
  final DateTime? loadedAt;
  final DateTime? unloadedAt;
  final String notes;
  final List<DmVanStockDocumentModel> history;

  bool get isLoaded => loadedAt != null;
  bool get isUnloaded => unloadedAt != null;

  int get totalLoaded => items.fold<int>(0, (sum, item) => sum + item.quantity);

  int get totalOnHand => items.fold<int>(0, (sum, item) => sum + item.onHand);

  int get totalExpected =>
      items.fold<int>(0, (sum, item) => sum + item.expected);

  bool get canLoad => !isLoaded && items.isNotEmpty;

  /// Unload is available after load until the session is closed — even if
  /// on-hand is already 0 (all delivered).
  bool get canUnload => isLoaded && !isUnloaded;

  DmVanStockModel copyWith({
    String? id,
    String? warehouseName,
    String? vehicleCode,
    DateTime? shiftDate,
    List<DmStockItemModel>? items,
    DateTime? loadedAt,
    DateTime? unloadedAt,
    String? notes,
    List<DmVanStockDocumentModel>? history,
    bool clearUnloadedAt = false,
  }) => DmVanStockModel(
    id: id ?? this.id,
    warehouseName: warehouseName ?? this.warehouseName,
    vehicleCode: vehicleCode ?? this.vehicleCode,
    shiftDate: shiftDate ?? this.shiftDate,
    items: items ?? this.items,
    loadedAt: loadedAt ?? this.loadedAt,
    unloadedAt: clearUnloadedAt ? null : (unloadedAt ?? this.unloadedAt),
    notes: notes ?? this.notes,
    history: history ?? this.history,
  );

  factory DmVanStockModel.fromJson(Map<String, dynamic> json) =>
      DmVanStockModel(
        id: ApiMap.asString(json['id']) ?? '',
        warehouseName: ApiMap.asString(json['warehouse_name']) ?? '',
        vehicleCode: ApiMap.asString(json['vehicle_code']) ?? '',
        shiftDate: ApiMap.asDateTime(json['shift_date']) ?? DateTime.now(),
        items: ApiMap.asMapList(
          json['items'],
        ).map(DmStockItemModel.fromJson).toList(growable: false),
        loadedAt: ApiMap.asDateTime(json['loaded_at']),
        unloadedAt: ApiMap.asDateTime(json['unloaded_at']),
        notes: ApiMap.asString(json['notes']) ?? '',
        history: ApiMap.asMapList(
          json['history'],
        ).map(DmVanStockDocumentModel.fromJson).toList(growable: false),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'warehouse_name': warehouseName,
    'vehicle_code': vehicleCode,
    'shift_date': shiftDate.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
    'loaded_at': loadedAt?.toIso8601String(),
    'unloaded_at': unloadedAt?.toIso8601String(),
    'notes': notes,
    'history': history.map((e) => e.toJson()).toList(),
  };
}
