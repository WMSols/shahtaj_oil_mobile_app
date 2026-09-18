import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmVanProductModel {
  const DmVanProductModel({
    required this.productId,
    required this.name,
    this.qtyInWarehouse = 0,
    this.qtyOnVan = 0,
    this.uom,
  });

  final int productId;
  final String name;
  final double qtyInWarehouse;
  final double qtyOnVan;
  final String? uom;

  factory DmVanProductModel.fromJson(Map<String, dynamic> json) {
    return DmVanProductModel(
      productId: ApiMap.asInt(json['product_id']) ?? 0,
      name: ApiMap.asString(json['name']) ?? '',
      qtyInWarehouse: ApiMap.asDouble(json['qty_in_warehouse']) ?? 0,
      qtyOnVan: ApiMap.asDouble(json['qty_on_van']) ?? 0,
      uom: ApiMap.asString(json['uom']),
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'name': name,
    'qty_in_warehouse': qtyInWarehouse,
    'qty_on_van': qtyOnVan,
    'uom': uom,
  };
}
