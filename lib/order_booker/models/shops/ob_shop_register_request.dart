import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class ObShopRegisterRequest {
  const ObShopRegisterRequest({
    required this.name,
    required this.ownerName,
    required this.ownerCnic,
    required this.ownerPhone,
    required this.latitude,
    required this.longitude,
    required this.shopType,
    this.zoneId,
    this.routeId,
    this.creditLimit,
    this.legacyBalance,
    this.ownerCnicFront,
    this.ownerCnicBack,
    this.ownerPhoto,
    this.shopExteriorPhoto,
  });

  final String name;
  final String ownerName;
  final String ownerCnic;
  final String ownerPhone;
  final double latitude;
  final double longitude;
  final ShopType shopType;
  final int? zoneId;
  final int? routeId;
  final double? creditLimit;
  final double? legacyBalance;
  final String? ownerCnicFront;
  final String? ownerCnicBack;
  final String? ownerPhoto;
  final String? shopExteriorPhoto;

  Map<String, dynamic> toJson() => {
    'name': name,
    'owner_name': ownerName,
    'owner_phone': ownerPhone,
    'latitude': latitude,
    'longitude': longitude,
    'shop_category': shopType.name,
    if (ownerCnic.trim().isNotEmpty) 'owner_cnic_number': ownerCnic.trim(),
    if (zoneId != null) 'zone_id': zoneId,
    if (routeId != null) 'route_id': routeId,
    if (creditLimit != null) 'credit_limit': creditLimit,
    if (legacyBalance != null) 'legacy_balance': legacyBalance,
    if (ownerCnicFront != null) 'owner_cnic_front': ownerCnicFront,
    if (ownerCnicBack != null) 'owner_cnic_back': ownerCnicBack,
    if (ownerPhoto != null) 'owner_photo': ownerPhoto,
    if (shopExteriorPhoto != null) 'shop_exterior_photo': shopExteriorPhoto,
  };
}
