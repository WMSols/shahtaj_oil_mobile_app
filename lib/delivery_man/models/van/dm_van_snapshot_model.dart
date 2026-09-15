import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmVanItemModel {
  const DmVanItemModel({
    required this.productId,
    required this.name,
    this.qty = 0,
    this.uom,
  });

  final int productId;
  final String name;
  final double qty;
  final String? uom;

  factory DmVanItemModel.fromJson(Map<String, dynamic> json) {
    return DmVanItemModel(
      productId: ApiMap.asInt(json['product_id']) ?? 0,
      name: ApiMap.asString(json['name']) ?? '',
      qty: ApiMap.asDouble(json['qty']) ?? 0,
      uom: ApiMap.asString(json['uom']),
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'name': name,
    'qty': qty,
    'uom': uom,
  };
}

class DmVanSnapshotModel {
  const DmVanSnapshotModel({
    this.vanLocationId,
    this.items = const [],
    this.qtyTotal = 0,
  });

  final int? vanLocationId;
  final List<DmVanItemModel> items;
  final double qtyTotal;

  factory DmVanSnapshotModel.fromJson(Map<String, dynamic> json) {
    return DmVanSnapshotModel(
      vanLocationId: ApiMap.asInt(json['van_location_id']),
      items: ApiMap.listOf(json, 'items')
          .map(DmVanItemModel.fromJson)
          .toList(growable: false),
      qtyTotal: ApiMap.asDouble(json['qty_total']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'van_location_id': vanLocationId,
    'items': items.map((e) => e.toJson()).toList(growable: false),
    'qty_total': qtyTotal,
  };
}
