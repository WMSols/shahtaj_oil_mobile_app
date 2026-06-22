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

  factory ObOrderLineModel.fromJson(Map<String, dynamic> json) =>
      ObOrderLineModel(
        productId: json['product_id']?.toString() ?? '',
        productName: json['product_name']?.toString() ?? '',
        quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
        unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_name': productName,
    'quantity': quantity,
    'unit_price': unitPrice,
  };
}
