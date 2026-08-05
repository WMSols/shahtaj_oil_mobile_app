import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_missing_field.dart';

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
    this.ownerCnicNumber,
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
    this.fieldVerified = true,
    this.needsShopSetup = false,
    this.visitTag = ShopVisitTag.visited,
    this.missingFields = const [],
  });

  final String id;
  final String name;
  final String? ownerName;
  final String? ownerCnicNumber;
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
  final bool fieldVerified;
  final bool needsShopSetup;
  final ShopVisitTag visitTag;
  final List<ObShopMissingField> missingFields;

  bool get hasCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.abs() <= 90 &&
      longitude!.abs() <= 180 &&
      !(latitude == 0 && longitude == 0);

  bool get isCreditShop => shopType == ShopType.credit;

  double? get resolvedCreditRemaining {
    if (creditRemaining != null) return creditRemaining;
    if (creditLimit == null || outstandingBalance == null) return null;
    return creditLimit! - outstandingBalance!;
  }

  factory ObShopModel.fromJson(Map<String, dynamic> json) {
    final photoFlags =
        ApiMap.asMap(json['photos']) ??
        ApiMap.asMap(json['verification_photos']);
    // When include_photos=true, base64 payloads live under photo_data.
    final photoData = ApiMap.asMap(json['photo_data']);
    final zone = ApiMap.asMap(json['zone']);
    final route = ApiMap.asMap(json['route']);
    final creditLimit = ApiMap.asDouble(json['credit_limit']);

    String? photo(String key, [List<String> aliases = const []]) {
      for (final name in [key, ...aliases]) {
        final data = _photoRef(photoData?[name]);
        if (data != null) return data;
      }
      for (final name in [key, ...aliases]) {
        final flagged = _photoRef(photoFlags?[name]);
        if (flagged != null) return flagged;
      }
      for (final name in [key, ...aliases]) {
        final topLevel = _photoRef(json[name]);
        if (topLevel != null) return topLevel;
      }
      return null;
    }

    final exterior = photo('shop_exterior_photo', ['shop_exterior']);
    final owner = photo('owner_photo');
    final needsShopSetup =
        json['needs_shop_setup'] == true || json['field_verified'] == false;
    final fieldVerified = !needsShopSetup;
    final visitTag = ShopVisitTagX.fromApi(
      json['visit_tag'] ?? (needsShopSetup ? 'not_visited' : 'visited'),
    );

    return ObShopModel(
      id: ApiMap.asString(json['id']) ?? ApiMap.asString(json['shop_id']) ?? '',
      name: ApiMap.asString(json['name']) ?? '',
      ownerName: ApiMap.asString(json['owner_name']),
      ownerCnicNumber: ApiMap.asString(json['owner_cnic_number']),
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
      heroImageAsset: ApiMap.asString(json['hero_image_asset']) ?? exterior,
      verificationPhotos: ObShopVerificationPhotos(
        cnicFront: photo('owner_cnic_front', ['cnic_front']),
        cnicBack: photo('owner_cnic_back', ['cnic_back']),
        ownerPhoto: owner,
        shopExterior: exterior,
      ),
      status: _parseStatus(json['status'] ?? json['approval_state']),
      isHighlighted: json['is_highlighted'] as bool? ?? false,
      fieldVerified: fieldVerified,
      needsShopSetup: needsShopSetup,
      visitTag: visitTag,
      missingFields: ObShopMissingField.listFrom(json['missing_fields']),
    );
  }

  static String? _photoRef(dynamic value) {
    if (value == null || value == false) return null;
    // API may send a presence flag without a loadable URL/path.
    if (value is bool) return null;
    if (value is String) {
      final text = value.trim();
      if (text.isEmpty || text.toLowerCase() == 'available') return null;
      return text;
    }
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return _photoRef(map['url']) ??
          _photoRef(map['image_url']) ??
          _photoRef(map['src']) ??
          _photoRef(map['path']) ??
          _photoRef(map['data']);
    }
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
    'owner_cnic_number': ownerCnicNumber,
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
    'field_verified': fieldVerified,
    'needs_shop_setup': needsShopSetup,
    'visit_tag': visitTag == ShopVisitTag.notVisited
        ? 'not_visited'
        : 'visited',
    'missing_fields': missingFields.map((f) => f.toJson()).toList(),
  };
}
