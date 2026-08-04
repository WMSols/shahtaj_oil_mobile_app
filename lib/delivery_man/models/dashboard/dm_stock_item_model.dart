import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmStockItemModel {
  const DmStockItemModel({
    required this.id,
    required this.name,
    this.quantity = 0,
    this.expectedQuantity,
    this.onHandQuantity,
    this.unit = '',
    this.isLowStock = false,
    this.imageAsset,
  });

  final String id;
  final String name;

  /// Loaded / confirmed quantity from warehouse pickup.
  final int quantity;

  /// Expected quantity from warehouse (defaults to [quantity] when null).
  final int? expectedQuantity;

  /// Remaining quantity currently on the van after deliveries.
  /// Defaults to [quantity] when null.
  final int? onHandQuantity;
  final String unit;
  final bool isLowStock;
  final String? imageAsset;

  int get expected => expectedQuantity ?? quantity;

  int get onHand => onHandQuantity ?? quantity;

  DmStockItemModel copyWith({
    String? id,
    String? name,
    int? quantity,
    int? expectedQuantity,
    int? onHandQuantity,
    String? unit,
    bool? isLowStock,
    String? imageAsset,
  }) => DmStockItemModel(
    id: id ?? this.id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    expectedQuantity: expectedQuantity ?? this.expectedQuantity,
    onHandQuantity: onHandQuantity ?? this.onHandQuantity,
    unit: unit ?? this.unit,
    isLowStock: isLowStock ?? this.isLowStock,
    imageAsset: imageAsset ?? this.imageAsset,
  );

  factory DmStockItemModel.fromJson(Map<String, dynamic> json) {
    return DmStockItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      expectedQuantity: ApiMap.asInt(json['expected_quantity']),
      onHandQuantity: ApiMap.asInt(json['on_hand_quantity']),
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
      'expected_quantity': expectedQuantity,
      'on_hand_quantity': onHandQuantity,
      'unit': unit,
      'is_low_stock': isLowStock,
      'image_asset': imageAsset,
    };
  }
}
