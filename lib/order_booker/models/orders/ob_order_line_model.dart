import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObOrderLineModel {
  const ObOrderLineModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.listPrice,
    this.unit = '',
  });

  final String productId;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double? listPrice;
  final String unit;

  double get lineTotal => quantity * unitPrice;

  double get appRate => listPrice ?? unitPrice;

  double get proposedRate => unitPrice;

  bool get isDiscounted => proposedRate < appRate - 0.001;

  factory ObOrderLineModel.fromJson(Map<String, dynamic> json) {
    final product = ApiMap.asMap(json['product']) ?? const <String, dynamic>{};
    final unitPrice =
        ApiMap.asDouble(json['unit_price']) ??
        ApiMap.asDouble(json['price_unit']) ??
        ApiMap.asDouble(product['list_price']) ??
        0;
    final listPrice =
        ApiMap.asDouble(json['list_price']) ??
        ApiMap.asDouble(json['app_rate']) ??
        ApiMap.asDouble(product['list_price']);

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
      unitPrice: unitPrice,
      listPrice: listPrice,
      unit:
          ApiMap.asString(json['unit']) ??
          ApiMap.asString(product['sale_uom']) ??
          ApiMap.asString(product['uom']) ??
          '',
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_name': productName,
    'quantity': quantity,
    'unit_price': unitPrice,
    'price_unit': unitPrice,
    if (listPrice != null) 'list_price': listPrice,
    'unit': unit,
  };
}
