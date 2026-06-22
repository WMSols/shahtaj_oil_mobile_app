import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class ObShopModel {
  const ObShopModel({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.status = ShopStatus.pending,
  });

  final String id;
  final String name;
  final String? address;
  final String? phone;
  final ShopStatus status;

  factory ObShopModel.fromJson(Map<String, dynamic> json) => ObShopModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    address: json['address']?.toString(),
    phone: json['phone']?.toString(),
    status: ShopStatus.values.firstWhere(
      (s) => s.name == json['status']?.toString(),
      orElse: () => ShopStatus.pending,
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'phone': phone,
    'status': status.name,
  };
}
