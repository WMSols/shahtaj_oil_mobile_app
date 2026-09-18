import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

/// Aggregated pick line from `load/today` → `pick_lines`.
class DmPickLineModel {
  const DmPickLineModel({
    required this.productId,
    required this.name,
    this.uom,
    this.qtyStill = 0,
    this.qtyAssigned = 0,
    this.qtyPicked = 0,
    this.qtyOnVan = 0,
    this.qtyInWarehouse = 0,
    this.qtyToPick = 0,
  });

  final int productId;
  final String name;
  final String? uom;
  final double qtyStill;
  final double qtyAssigned;
  final double qtyPicked;
  final double qtyOnVan;
  final double qtyInWarehouse;
  final double qtyToPick;

  factory DmPickLineModel.fromJson(Map<String, dynamic> json) {
    return DmPickLineModel(
      productId: ApiMap.asInt(json['product_id']) ?? 0,
      name: ApiMap.asString(json['name']) ?? '',
      uom: ApiMap.asString(json['uom']),
      qtyStill: ApiMap.asDouble(json['qty_still']) ?? 0,
      qtyAssigned: ApiMap.asDouble(json['qty_assigned']) ?? 0,
      qtyPicked: ApiMap.asDouble(json['qty_picked']) ?? 0,
      qtyOnVan: ApiMap.asDouble(json['qty_on_van']) ?? 0,
      qtyInWarehouse: ApiMap.asDouble(json['qty_in_warehouse']) ?? 0,
      qtyToPick: ApiMap.asDouble(json['qty_to_pick']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'name': name,
    'uom': uom,
    'qty_still': qtyStill,
    'qty_assigned': qtyAssigned,
    'qty_picked': qtyPicked,
    'qty_on_van': qtyOnVan,
    'qty_in_warehouse': qtyInWarehouse,
    'qty_to_pick': qtyToPick,
  };
}
