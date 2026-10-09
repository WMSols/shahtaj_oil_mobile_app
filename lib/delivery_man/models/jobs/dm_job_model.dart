import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_line_model.dart';

class DmJobModel {
  const DmJobModel({
    required this.jobId,
    required this.shopId,
    required this.shopName,
    this.shopAddress,
    this.latitude,
    this.longitude,
    this.orderName,
    this.state = DmJobState.notReady,
    this.fieldState = DmFieldState.pending,
    this.scheduledDate,
    this.qtyOnVan,
    this.notes,
    this.receiverName,
    this.hasDeliveryProof = false,
    this.hasShopClosedPhoto = false,
    this.gpsVerified = false,
    this.isWalkIn = false,
    this.lines = const [],
  });

  final int jobId;
  final String shopId;
  final String shopName;
  final String? shopAddress;
  final double? latitude;
  final double? longitude;
  final String? orderName;
  final DmJobState state;
  final DmFieldState fieldState;
  final DateTime? scheduledDate;
  final double? qtyOnVan;
  final String? notes;
  final String? receiverName;
  final bool hasDeliveryProof;
  final bool hasShopClosedPhoto;
  final bool gpsVerified;
  final bool isWalkIn;
  final List<DmJobLineModel> lines;

  bool get hasShopCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.abs() <= 90 &&
      longitude!.abs() <= 180 &&
      !(latitude == 0 && longitude == 0);

  factory DmJobModel.fromJson(Map<String, dynamic> json) {
    return DmJobModel(
      jobId: ApiMap.asInt(json['job_id'] ?? json['id']) ?? 0,
      shopId: (ApiMap.asInt(json['shop_id']) ?? json['shop_id'] ?? '')
          .toString(),
      shopName: ApiMap.asString(json['shop_name']) ?? '',
      shopAddress: ApiMap.asString(json['shop_address']),
      latitude: ApiMap.asDouble(json['latitude']),
      longitude: ApiMap.asDouble(json['longitude']),
      orderName: ApiMap.asString(json['order_name']),
      state:
          DmJobStateX.tryParse(ApiMap.asString(json['state'])) ??
          DmJobState.notReady,
      fieldState:
          DmFieldStateX.tryParse(ApiMap.asString(json['field_state'])) ??
          DmFieldState.pending,
      scheduledDate: ApiMap.asDateTime(json['scheduled_date']),
      qtyOnVan: ApiMap.asDouble(json['qty_on_van']),
      notes: ApiMap.asString(json['notes']),
      receiverName: ApiMap.asString(json['receiver_name']),
      hasDeliveryProof: ApiMap.asBool(json['has_delivery_proof']),
      hasShopClosedPhoto: ApiMap.asBool(json['has_shop_closed_photo']),
      gpsVerified: ApiMap.asBool(json['gps_verified']),
      isWalkIn: _parseWalkIn(json),
      lines: ApiMap.listOf(
        json,
        'lines',
      ).map(DmJobLineModel.fromJson).toList(growable: false),
    );
  }

  static bool _parseWalkIn(Map<String, dynamic> json) {
    const keys = [
      'is_walk_in',
      'walk_in',
      'is_walkin',
      'walkin',
      'is_walk_in_delivery',
      'walk_in_delivery',
      'is_cash_and_carry',
    ];
    for (final key in keys) {
      if (json.containsKey(key) && ApiMap.asBool(json[key])) return true;
    }

    for (final key in [
      'job_type',
      'delivery_type',
      'origin',
      'source',
      'sale_type',
      'partner_type',
    ]) {
      final type = (ApiMap.asString(json[key]) ?? '')
          .trim()
          .toLowerCase()
          .replaceAll('-', '_')
          .replaceAll(' ', '_');
      if (type.contains('walk_in') ||
          type.contains('walkin') ||
          type == 'cash_and_carry') {
        return true;
      }
    }

    final partner = ApiMap.asMap(json['partner']);
    if (partner != null && _parseWalkIn(partner)) return true;

    return false;
  }

  Map<String, dynamic> toJson() => {
    'job_id': jobId,
    'shop_id': shopId,
    'shop_name': shopName,
    'shop_address': shopAddress,
    'latitude': latitude,
    'longitude': longitude,
    'order_name': orderName,
    'state': switch (state) {
      DmJobState.notReady => 'not_ready',
      DmJobState.ready => 'ready',
      DmJobState.picked => 'picked',
      DmJobState.partial => 'partial',
      DmJobState.delivered => 'delivered',
      DmJobState.returned => 'returned',
    },
    'field_state': switch (fieldState) {
      DmFieldState.pending => 'pending',
      DmFieldState.inTransit => 'in_transit',
      DmFieldState.notAttended => 'not_attended',
      DmFieldState.failed => 'failed',
      DmFieldState.done => 'done',
    },
    'scheduled_date': scheduledDate?.toIso8601String(),
    'qty_on_van': qtyOnVan,
    'notes': notes,
    'receiver_name': receiverName,
    'has_delivery_proof': hasDeliveryProof,
    'has_shop_closed_photo': hasShopClosedPhoto,
    'gps_verified': gpsVerified,
    'is_walk_in': isWalkIn,
    'lines': lines.map((e) => e.toJson()).toList(growable: false),
  };

  DmJobModel copyWith({
    int? jobId,
    String? shopId,
    String? shopName,
    String? shopAddress,
    double? latitude,
    double? longitude,
    String? orderName,
    DmJobState? state,
    DmFieldState? fieldState,
    DateTime? scheduledDate,
    double? qtyOnVan,
    String? notes,
    String? receiverName,
    bool? hasDeliveryProof,
    bool? hasShopClosedPhoto,
    bool? gpsVerified,
    bool? isWalkIn,
    List<DmJobLineModel>? lines,
  }) {
    return DmJobModel(
      jobId: jobId ?? this.jobId,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      shopAddress: shopAddress ?? this.shopAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      orderName: orderName ?? this.orderName,
      state: state ?? this.state,
      fieldState: fieldState ?? this.fieldState,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      qtyOnVan: qtyOnVan ?? this.qtyOnVan,
      notes: notes ?? this.notes,
      receiverName: receiverName ?? this.receiverName,
      hasDeliveryProof: hasDeliveryProof ?? this.hasDeliveryProof,
      hasShopClosedPhoto: hasShopClosedPhoto ?? this.hasShopClosedPhoto,
      gpsVerified: gpsVerified ?? this.gpsVerified,
      isWalkIn: isWalkIn ?? this.isWalkIn,
      lines: lines ?? this.lines,
    );
  }
}
