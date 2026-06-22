class ObRouteModel {
  const ObRouteModel({
    required this.id,
    required this.name,
    this.description,
    this.shopCount = 0,
  });

  final String id;
  final String name;
  final String? description;
  final int shopCount;

  factory ObRouteModel.fromJson(Map<String, dynamic> json) => ObRouteModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    description: json['description']?.toString(),
    shopCount: json['shop_count'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'shop_count': shopCount,
  };
}
