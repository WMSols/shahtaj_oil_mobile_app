import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class ObShopVerificationPhotos {
  const ObShopVerificationPhotos({
    this.cnicFront,
    this.cnicBack,
    this.ownerPhoto,
    this.shopExterior,
  });

  final String? cnicFront;
  final String? cnicBack;
  final String? ownerPhoto;
  final String? shopExterior;
}

class ObShopModel {
  const ObShopModel({
    required this.id,
    required this.name,
    this.ownerName,
    this.phone,
    this.locationLabel,
    this.address,
    this.zoneName,
    this.routeName,
    this.creditLimit,
    this.legacyBalance,
    this.latitude,
    this.longitude,
    this.heroImageAsset,
    this.verificationPhotos = const ObShopVerificationPhotos(),
    this.status = ShopStatus.pending,
    this.isHighlighted = false,
  });

  final String id;
  final String name;
  final String? ownerName;
  final String? phone;
  final String? locationLabel;
  final String? address;
  final String? zoneName;
  final String? routeName;
  final double? creditLimit;
  final double? legacyBalance;
  final double? latitude;
  final double? longitude;
  final String? heroImageAsset;
  final ObShopVerificationPhotos verificationPhotos;
  final ShopStatus status;
  final bool isHighlighted;

  bool get hasCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.abs() <= 90 &&
      longitude!.abs() <= 180;

  factory ObShopModel.fromJson(Map<String, dynamic> json) {
    final photos = json['verification_photos'] as Map<String, dynamic>?;

    return ObShopModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      ownerName: json['owner_name']?.toString(),
      phone: json['phone']?.toString(),
      locationLabel: json['location_label']?.toString(),
      address: json['address']?.toString(),
      zoneName: json['zone_name']?.toString(),
      routeName: json['route_name']?.toString(),
      creditLimit: _readDouble(json['credit_limit']),
      legacyBalance: _readDouble(json['legacy_balance']),
      latitude: _readDouble(json['latitude']),
      longitude: _readDouble(json['longitude']),
      heroImageAsset: json['hero_image_asset']?.toString(),
      verificationPhotos: ObShopVerificationPhotos(
        cnicFront: photos?['cnic_front']?.toString(),
        cnicBack: photos?['cnic_back']?.toString(),
        ownerPhoto: photos?['owner_photo']?.toString(),
        shopExterior: photos?['shop_exterior']?.toString(),
      ),
      status: ShopStatus.values.firstWhere(
        (s) => s.name == json['status']?.toString(),
        orElse: () => ShopStatus.pending,
      ),
      isHighlighted: json['is_highlighted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'owner_name': ownerName,
    'phone': phone,
    'location_label': locationLabel,
    'address': address,
    'zone_name': zoneName,
    'route_name': routeName,
    'credit_limit': creditLimit,
    'legacy_balance': legacyBalance,
    'latitude': latitude,
    'longitude': longitude,
    'hero_image_asset': heroImageAsset,
    'verification_photos': {
      'cnic_front': verificationPhotos.cnicFront,
      'cnic_back': verificationPhotos.cnicBack,
      'owner_photo': verificationPhotos.ownerPhoto,
      'shop_exterior': verificationPhotos.shopExterior,
    },
    'status': status.name,
    'is_highlighted': isHighlighted,
  };
}

double? _readDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
