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
    id:
        (json['product_id'] as num?)?.toInt() ??
        (json['id'] as num?)?.toInt() ??
        0,
    name: json['name']?.toString() ?? '',
    unit: json['unit']?.toString() ?? '',
    priceUnit: (json['price_unit'] as num?)?.toDouble() ?? 0,
    qtyBookable: (json['qty_bookable'] as num?)?.toDouble() ?? 0,
    sku: json['sku']?.toString(),
    imageUrl: json['image_url']?.toString(),
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
