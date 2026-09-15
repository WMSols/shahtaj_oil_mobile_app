import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmFreeShopModel {
  const DmFreeShopModel({
    required this.shopId,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
  });

  final String shopId;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;

  bool get hasCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.abs() <= 90 &&
      longitude!.abs() <= 180 &&
      !(latitude == 0 && longitude == 0);

  factory DmFreeShopModel.fromJson(Map<String, dynamic> json) {
    return DmFreeShopModel(
      shopId: (ApiMap.asInt(json['shop_id']) ?? json['shop_id'] ?? '').toString(),
      name: ApiMap.asString(json['name']) ?? '',
      address: ApiMap.asString(json['address']),
      latitude: ApiMap.asDouble(json['latitude']),
      longitude: ApiMap.asDouble(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() => {
    'shop_id': shopId,
    'name': name,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
  };
}
