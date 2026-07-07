class DmStockItemModel {
  const DmStockItemModel({
    required this.id,
    required this.name,
    this.quantity = 0,
    this.unit = '',
    this.isLowStock = false,
    this.imageAsset,
  });

  final String id;
  final String name;
  final int quantity;
  final String unit;
  final bool isLowStock;
  final String? imageAsset;

  factory DmStockItemModel.fromJson(Map<String, dynamic> json) {
    return DmStockItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unit: json['unit']?.toString() ?? '',
      isLowStock: json['is_low_stock'] == true,
      imageAsset: json['image_asset']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'is_low_stock': isLowStock,
      'image_asset': imageAsset,
    };
  }
}
