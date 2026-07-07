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

  factory ObVisitCartLineModel.fromJson(Map<String, dynamic> json) =>
      ObVisitCartLineModel(
        lineId: (json['line_id'] as num?)?.toInt() ?? 0,
        productId: (json['product_id'] as num?)?.toInt() ?? 0,
        productName: json['product_name']?.toString() ?? '',
        quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
        priceUnit: (json['price_unit'] as num?)?.toDouble() ?? 0,
        unit: json['unit']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'line_id': lineId,
    'product_id': productId,
    'product_name': productName,
    'quantity': quantity,
    'price_unit': priceUnit,
    'unit': unit,
  };
}
