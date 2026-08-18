import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_missing_field.dart';

class ObTaskModel {
  const ObTaskModel({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.sequence,
    this.ownerName,
    this.ownerCnicNumber,
    this.phone,
    this.locationLabel,
    this.status = TaskStatus.pending,
    this.notes,
    this.shopLatitude,
    this.shopLongitude,
    this.fieldVerified = true,
    this.needsShopSetup = false,
    this.visitTag = ShopVisitTag.visited,
    this.missingFields = const [],
    this.shopType,
  });

  final int id;
  final String shopId;
  final String shopName;
  final String? ownerName;
  final String? ownerCnicNumber;
  final String? phone;
  final String? locationLabel;
  final int sequence;
  final TaskStatus status;
  final String? notes;
  final double? shopLatitude;
  final double? shopLongitude;
  final bool fieldVerified;
  final bool needsShopSetup;
  final ShopVisitTag visitTag;
  final List<ObShopMissingField> missingFields;
  final ShopType? shopType;

  bool get hasShopCoordinates =>
      shopLatitude != null &&
      shopLongitude != null &&
      shopLatitude!.abs() <= 90 &&
      shopLongitude!.abs() <= 180 &&
      !(shopLatitude == 0 && shopLongitude == 0);

  ObTaskModel copyWith({
    int? id,
    String? shopId,
    String? shopName,
    String? ownerName,
    String? ownerCnicNumber,
    String? phone,
    String? locationLabel,
    int? sequence,
    TaskStatus? status,
    String? notes,
    double? shopLatitude,
    double? shopLongitude,
    bool? fieldVerified,
    bool? needsShopSetup,
    ShopVisitTag? visitTag,
    List<ObShopMissingField>? missingFields,
    ShopType? shopType,
  }) => ObTaskModel(
    id: id ?? this.id,
    shopId: shopId ?? this.shopId,
    shopName: shopName ?? this.shopName,
    ownerName: ownerName ?? this.ownerName,
    ownerCnicNumber: ownerCnicNumber ?? this.ownerCnicNumber,
    phone: phone ?? this.phone,
    locationLabel: locationLabel ?? this.locationLabel,
    sequence: sequence ?? this.sequence,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    shopLatitude: shopLatitude ?? this.shopLatitude,
    shopLongitude: shopLongitude ?? this.shopLongitude,
    fieldVerified: fieldVerified ?? this.fieldVerified,
    needsShopSetup: needsShopSetup ?? this.needsShopSetup,
    visitTag: visitTag ?? this.visitTag,
    missingFields: missingFields ?? this.missingFields,
    shopType: shopType ?? this.shopType,
  );

  factory ObTaskModel.fromJson(Map<String, dynamic> json) {
    final shop = ApiMap.asMap(json['shop']) ?? const <String, dynamic>{};
    final needsShopSetup =
        json['needs_shop_setup'] == true ||
        shop['needs_shop_setup'] == true ||
        json['field_verified'] == false ||
        shop['field_verified'] == false;
    final fieldVerified = !needsShopSetup;
    final visitTag = ShopVisitTagX.fromApi(
      json['visit_tag'] ??
          shop['visit_tag'] ??
          (needsShopSetup ? 'not_visited' : 'visited'),
    );
    final missing = ObShopMissingField.listFrom(
      json['missing_fields'] ?? shop['missing_fields'],
    );

    return ObTaskModel(
      id: ApiMap.asInt(json['task_id']) ?? ApiMap.asInt(json['id']) ?? 0,
      shopId:
          ApiMap.asString(json['shop_id']) ??
          ApiMap.asString(shop['shop_id']) ??
          ApiMap.asString(shop['id']) ??
          '',
      shopName:
          ApiMap.asString(json['shop_name']) ??
          ApiMap.asString(shop['name']) ??
          '',
      ownerName:
          ApiMap.asString(json['owner_name']) ??
          ApiMap.asString(shop['owner_name']),
      ownerCnicNumber:
          ApiMap.asString(json['owner_cnic_number']) ??
          ApiMap.asString(shop['owner_cnic_number']),
      phone:
          ApiMap.asString(json['phone']) ??
          ApiMap.asString(shop['owner_phone']),
      locationLabel: ApiMap.asString(json['location_label']),
      sequence: ApiMap.asInt(json['sequence']) ?? 0,
      status: _parseStatus(json['status'] ?? json['state']),
      notes: ApiMap.asString(json['notes']),
      shopLatitude:
          ApiMap.asDouble(json['shop_latitude']) ??
          ApiMap.asDouble(shop['latitude']),
      shopLongitude:
          ApiMap.asDouble(json['shop_longitude']) ??
          ApiMap.asDouble(shop['longitude']),
      fieldVerified: fieldVerified,
      needsShopSetup: needsShopSetup,
      visitTag: visitTag,
      missingFields: missing,
      shopType: _parseShopType(
        json['shop_category'] ??
            json['shopCategory'] ??
            shop['shop_category'] ??
            shop['shopCategory'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'task_id': id,
    'shop_id': shopId,
    'shop_name': shopName,
    'owner_name': ownerName,
    'owner_cnic_number': ownerCnicNumber,
    'phone': phone,
    'location_label': locationLabel,
    'sequence': sequence,
    'status': status.name,
    'notes': notes,
    'shop_latitude': shopLatitude,
    'shop_longitude': shopLongitude,
    'field_verified': fieldVerified,
    'needs_shop_setup': needsShopSetup,
    'visit_tag': visitTag == ShopVisitTag.notVisited
        ? 'not_visited'
        : 'visited',
    'missing_fields': missingFields.map((f) => f.toJson()).toList(),
    if (shopType != null) 'shop_category': shopType!.name,
  };

  static ShopType? _parseShopType(dynamic value) {
    if (value == null) return null;
    if (value is ShopType) return value;
    final raw = value.toString().trim().toLowerCase();
    if (raw == ShopType.cash.name) return ShopType.cash;
    if (raw == ShopType.credit.name) return ShopType.credit;
    return null;
  }

  static TaskStatus _parseStatus(dynamic value) {
    final raw = value?.toString() ?? '';
    final normalized = ApiMap.snakeToCamel(raw);
    if (normalized == 'inProgress' || normalized == 'checkedIn') {
      return TaskStatus.inVisit;
    }
    // Legacy API may still send "skipped"; treat as pending so the shop stays actionable.
    if (normalized == 'skipped' || raw == 'skip') {
      return TaskStatus.pending;
    }
    return TaskStatus.values.firstWhere(
      (status) => status.name == raw || status.name == normalized,
      orElse: () => TaskStatus.pending,
    );
  }
}
