import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmJobLineModel {
  const DmJobLineModel({
    required this.lineId,
    required this.productId,
    required this.name,
    this.uom,
    this.qtyAssigned = 0,
    this.qtyPicked = 0,
    this.qtyStill = 0,
    this.qtyDelivered = 0,
    this.qtyOnVan,
  });

  final int lineId;
  final int productId;
  final String name;
  final String? uom;
  final double qtyAssigned;
  final double qtyPicked;
  final double qtyStill;
  final double qtyDelivered;
  final double? qtyOnVan;

  factory DmJobLineModel.fromJson(Map<String, dynamic> json) {
    return DmJobLineModel(
      lineId: ApiMap.asInt(json['line_id'] ?? json['id']) ?? 0,
      productId: ApiMap.asInt(json['product_id']) ?? 0,
      name: ApiMap.asString(json['name']) ?? '',
      uom: ApiMap.asString(json['uom']),
      qtyAssigned: ApiMap.asDouble(json['qty_assigned']) ?? 0,
      qtyPicked: ApiMap.asDouble(json['qty_picked']) ?? 0,
      qtyStill: ApiMap.asDouble(json['qty_still']) ?? 0,
      qtyDelivered: ApiMap.asDouble(json['qty_delivered']) ?? 0,
      qtyOnVan: ApiMap.asDouble(json['qty_on_van']),
    );
  }

  Map<String, dynamic> toJson() => {
    'line_id': lineId,
    'product_id': productId,
    'name': name,
    'uom': uom,
    'qty_assigned': qtyAssigned,
    'qty_picked': qtyPicked,
    'qty_still': qtyStill,
    'qty_delivered': qtyDelivered,
    'qty_on_van': qtyOnVan,
  };
}
