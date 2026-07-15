import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObVisitCartLineModel {
  const ObVisitCartLineModel({
    required this.lineId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceUnit,
    this.unit,
  });

  final int lineId;
  final int productId;
  final String productName;
  final double quantity;
  final double priceUnit;
  final String? unit;

  double get lineTotal => quantity * priceUnit;

  ObVisitCartLineModel copyWith({
    int? lineId,
    int? productId,
    String? productName,
    double? quantity,
    double? priceUnit,
    String? unit,
  }) => ObVisitCartLineModel(
    lineId: lineId ?? this.lineId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    priceUnit: priceUnit ?? this.priceUnit,
    unit: unit ?? this.unit,
  );

  factory ObVisitCartLineModel.fromJson(Map<String, dynamic> json) {
    final product = ApiMap.asMap(json['product']) ?? const <String, dynamic>{};
    return ObVisitCartLineModel(
      lineId: ApiMap.asInt(json['line_id']) ?? ApiMap.asInt(json['id']) ?? 0,
      productId:
          ApiMap.asInt(json['product_id']) ?? ApiMap.asInt(product['id']) ?? 0,
      productName:
          ApiMap.asString(json['product_name']) ??
          ApiMap.asString(product['name']) ??
          '',
      quantity: ApiMap.asDouble(json['quantity']) ?? 0,
      priceUnit:
          ApiMap.asDouble(json['price_unit']) ??
          ApiMap.asDouble(product['list_price']) ??
          0,
      unit:
          ApiMap.asString(json['unit']) ??
          ApiMap.asString(product['sale_uom']) ??
          ApiMap.asString(product['uom']),
    );
  }

  Map<String, dynamic> toJson() => {
    'line_id': lineId,
    'product_id': productId,
    'product_name': productName,
    'quantity': quantity,
    'price_unit': priceUnit,
    'unit': unit,
  };
}
