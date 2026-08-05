import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObOrderLineModel {
  const ObOrderLineModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  final String productId;
  final String productName;
  final double quantity;
  final double unitPrice;

  double get lineTotal => quantity * unitPrice;

  factory ObOrderLineModel.fromJson(Map<String, dynamic> json) {
    final product = ApiMap.asMap(json['product']) ?? const <String, dynamic>{};
    return ObOrderLineModel(
      productId:
          ApiMap.asString(json['product_id']) ??
          ApiMap.asString(product['id']) ??
          '',
      productName:
          ApiMap.asString(json['product_name']) ??
          ApiMap.asString(product['name']) ??
          '',
      quantity: ApiMap.asDouble(json['quantity']) ?? 0,
      unitPrice:
          ApiMap.asDouble(json['unit_price']) ??
          ApiMap.asDouble(json['price_unit']) ??
          ApiMap.asDouble(product['list_price']) ??
          0,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_name': productName,
    'quantity': quantity,
    'unit_price': unitPrice,
  };
}
