import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

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
    this.shopType = ShopType.credit,
    this.creditLimit,
    this.outstandingBalance,
    this.creditRemaining,
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
  final ShopType shopType;
  final double? creditLimit;
  final double? outstandingBalance;
  final double? creditRemaining;
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

  bool get isCreditShop => shopType == ShopType.credit;

  double? get resolvedCreditRemaining {
    if (creditRemaining != null) return creditRemaining;
    if (creditLimit == null || outstandingBalance == null) return null;
    return creditLimit! - outstandingBalance!;
  }

  factory ObShopModel.fromJson(Map<String, dynamic> json) {
    final photos =
        ApiMap.asMap(json['verification_photos']) ??
        ApiMap.asMap(json['photos']);
    final zone = ApiMap.asMap(json['zone']);
    final route = ApiMap.asMap(json['route']);
    final creditLimit = ApiMap.asDouble(json['credit_limit']);

    return ObShopModel(
      id: ApiMap.asString(json['id']) ?? ApiMap.asString(json['shop_id']) ?? '',
      name: ApiMap.asString(json['name']) ?? '',
      ownerName: ApiMap.asString(json['owner_name']),
      phone:
          ApiMap.asString(json['phone']) ??
          ApiMap.asString(json['owner_phone']),
      locationLabel: ApiMap.asString(json['location_label']),
      address: ApiMap.asString(json['address']),
      zoneName:
          ApiMap.asString(json['zone_name']) ?? ApiMap.asString(zone?['name']),
      routeName:
          ApiMap.asString(json['route_name']) ??
          ApiMap.asString(route?['name']),
      shopType: _parseShopType(json['shop_category']),
      creditLimit: creditLimit,
      outstandingBalance: ApiMap.asDouble(json['outstanding_balance']),
      creditRemaining: ApiMap.asDouble(json['credit_remaining']),
      legacyBalance: ApiMap.asDouble(json['legacy_balance']),
      latitude: ApiMap.asDouble(json['latitude']),
      longitude: ApiMap.asDouble(json['longitude']),
      heroImageAsset: ApiMap.asString(json['hero_image_asset']),
      verificationPhotos: ObShopVerificationPhotos(
        cnicFront:
            _photoRef(photos?['cnic_front']) ??
            _photoRef(photos?['owner_cnic_front']),
        cnicBack:
            _photoRef(photos?['cnic_back']) ??
            _photoRef(photos?['owner_cnic_back']),
        ownerPhoto: _photoRef(photos?['owner_photo']),
        shopExterior:
            _photoRef(photos?['shop_exterior']) ??
            _photoRef(photos?['shop_exterior_photo']),
      ),
      status: _parseStatus(json['status'] ?? json['approval_state']),
      isHighlighted: json['is_highlighted'] as bool? ?? false,
    );
  }

  static String? _photoRef(dynamic value) {
    if (value is String && value.trim().isNotEmpty) return value;
    if (value is bool) return value ? 'available' : null;
    return null;
  }

  static ShopStatus _parseStatus(dynamic value) {
    final raw = value?.toString() ?? '';
    final normalized = ApiMap.snakeToCamel(raw);
    return ShopStatus.values.firstWhere(
      (status) => status.name == raw || status.name == normalized,
      orElse: () => ShopStatus.pending,
    );
  }

  static ShopType _parseShopType(dynamic value) {
    final raw = value?.toString().trim().toLowerCase();
    if (raw == ShopType.cash.name) return ShopType.cash;
    if (raw == ShopType.credit.name) return ShopType.credit;
    return ShopType.credit;
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
    'shop_category': shopType.name,
    'credit_limit': creditLimit,
    'outstanding_balance': outstandingBalance,
    'credit_remaining': creditRemaining,
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
