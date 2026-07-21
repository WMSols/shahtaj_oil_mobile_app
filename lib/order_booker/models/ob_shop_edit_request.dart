import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class ObShopEditRequest {
  const ObShopEditRequest({
    required this.shopId,
    required this.name,
    required this.ownerName,
    required this.ownerPhone,
    required this.latitude,
    required this.longitude,
    required this.shopType,
    this.creditLimit,
    this.legacyBalance,
  });

  final String shopId;
  final String name;
  final String ownerName;
  final String ownerPhone;
  final double latitude;
  final double longitude;
  final ShopType shopType;
  final double? creditLimit;
  final double? legacyBalance;

  Map<String, dynamic> toJson() {
    return {
      'shop_id': int.tryParse(shopId) ?? shopId,
      'name': name,
      'owner_name': ownerName,
      'owner_phone': ownerPhone,
      'latitude': latitude,
      'longitude': longitude,
      'shop_category': shopType.name,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (legacyBalance != null) 'legacy_balance': legacyBalance,
    };
  }
}
