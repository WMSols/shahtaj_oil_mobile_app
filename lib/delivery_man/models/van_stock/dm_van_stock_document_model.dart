import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';

enum DmVanStockDocumentKind { load, unload }

class DmVanStockDocumentModel {
  const DmVanStockDocumentModel({
    required this.id,
    required this.kind,
    required this.at,
    required this.items,
    this.notes = '',
  });

  final String id;
  final DmVanStockDocumentKind kind;
  final DateTime at;
  final List<DmStockItemModel> items;
  final String notes;

  int get totalQty => items.fold<int>(0, (sum, item) => sum + item.quantity);

  factory DmVanStockDocumentModel.fromJson(Map<String, dynamic> json) =>
      DmVanStockDocumentModel(
        id: ApiMap.asString(json['id']) ?? '',
        kind: DmVanStockDocumentKind.values.firstWhere(
          (k) => k.name == json['kind']?.toString(),
          orElse: () => DmVanStockDocumentKind.load,
        ),
        at: ApiMap.asDateTime(json['at']) ?? DateTime.now(),
        items: ApiMap.asMapList(
          json['items'],
        ).map(DmStockItemModel.fromJson).toList(growable: false),
        notes: ApiMap.asString(json['notes']) ?? '',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'at': at.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
    'notes': notes,
  };
}
