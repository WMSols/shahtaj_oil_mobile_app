import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmOrderLineModel {
  const DmOrderLineModel({
    required this.id,
    required this.productName,
    this.unit = '',
    this.orderedQty = 0,
    this.loadedQty = 0,
    this.deliveredQty = 0,
    this.rejectedQty = 0,
    this.unitPrice = 0,
  });

  final String id;
  final String productName;
  final String unit;
  final double orderedQty;
  final double loadedQty;
  final double deliveredQty;
  final double rejectedQty;
  final double unitPrice;

  /// Remaining after delivered + rejected (undelivered rest on van).
  double get leftoverQty {
    final left = loadedQty - deliveredQty - rejectedQty;
    return left < 0 ? 0 : left;
  }

  /// Stock to send back on return — leftover + rejected (all treated as leftover).
  double get returnableQty => leftoverQty + (rejectedQty < 0 ? 0 : rejectedQty);

  double get lineTotal => deliveredQty > 0
      ? deliveredQty * unitPrice
      : (loadedQty > 0 ? loadedQty : orderedQty) * unitPrice;

  DmOrderLineModel copyWith({
    String? id,
    String? productName,
    String? unit,
    double? orderedQty,
    double? loadedQty,
    double? deliveredQty,
    double? rejectedQty,
    double? unitPrice,
  }) => DmOrderLineModel(
    id: id ?? this.id,
    productName: productName ?? this.productName,
    unit: unit ?? this.unit,
    orderedQty: orderedQty ?? this.orderedQty,
    loadedQty: loadedQty ?? this.loadedQty,
    deliveredQty: deliveredQty ?? this.deliveredQty,
    rejectedQty: rejectedQty ?? this.rejectedQty,
    unitPrice: unitPrice ?? this.unitPrice,
  );

  factory DmOrderLineModel.fromJson(Map<String, dynamic> json) =>
      DmOrderLineModel(
        id: ApiMap.asString(json['id']) ?? '',
        productName: ApiMap.asString(json['product_name']) ?? '',
        unit: ApiMap.asString(json['unit']) ?? '',
        orderedQty: ApiMap.asDouble(json['ordered_qty']) ?? 0,
        loadedQty: ApiMap.asDouble(json['loaded_qty']) ?? 0,
        deliveredQty: ApiMap.asDouble(json['delivered_qty']) ?? 0,
        rejectedQty: ApiMap.asDouble(json['rejected_qty']) ?? 0,
        unitPrice: ApiMap.asDouble(json['unit_price']) ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_name': productName,
    'unit': unit,
    'ordered_qty': orderedQty,
    'loaded_qty': loadedQty,
    'delivered_qty': deliveredQty,
    'rejected_qty': rejectedQty,
    'unit_price': unitPrice,
  };
}
