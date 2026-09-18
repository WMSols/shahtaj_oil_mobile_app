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
    this.gpsVerified = false,
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
  final bool gpsVerified;
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
      hasDeliveryProof: json['has_delivery_proof'] == true,
      gpsVerified: json['gps_verified'] == true,
      lines: ApiMap.listOf(
        json,
        'lines',
      ).map(DmJobLineModel.fromJson).toList(growable: false),
    );
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
    'gps_verified': gpsVerified,
    'lines': lines.map((e) => e.toJson()).toList(growable: false),
  };
}
