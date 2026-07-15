import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObProductModel {
  const ObProductModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.priceUnit,
    required this.qtyBookable,
    this.sku,
    this.imageUrl,
  });

  final int id;
  final String name;
  final String unit;
  final double priceUnit;
  final double qtyBookable;
  final String? sku;
  final String? imageUrl;

  ObProductModel copyWith({
    int? id,
    String? name,
    String? unit,
    double? priceUnit,
    double? qtyBookable,
    String? sku,
    String? imageUrl,
  }) => ObProductModel(
    id: id ?? this.id,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    priceUnit: priceUnit ?? this.priceUnit,
    qtyBookable: qtyBookable ?? this.qtyBookable,
    sku: sku ?? this.sku,
    imageUrl: imageUrl ?? this.imageUrl,
  );

  factory ObProductModel.fromJson(Map<String, dynamic> json) => ObProductModel(
    id: ApiMap.asInt(json['product_id']) ?? ApiMap.asInt(json['id']) ?? 0,
    name: ApiMap.asString(json['name']) ?? '',
    unit:
        ApiMap.asString(json['unit']) ??
        ApiMap.asString(json['sale_uom']) ??
        ApiMap.asString(json['uom']) ??
        '',
    priceUnit:
        ApiMap.asDouble(json['price_unit']) ??
        ApiMap.asDouble(json['list_price']) ??
        0,
    qtyBookable: ApiMap.asDouble(json['qty_bookable']) ?? 0,
    sku: ApiMap.asString(json['sku']),
    imageUrl: ApiMap.asString(json['image_url']),
  );

  Map<String, dynamic> toJson() => {
    'product_id': id,
    'name': name,
    'unit': unit,
    'price_unit': priceUnit,
    'qty_bookable': qtyBookable,
    'sku': sku,
    'image_url': imageUrl,
  };
}
