import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_order_line_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_timeline_event_model.dart';

class DmDeliveryOrderModel {
  const DmDeliveryOrderModel({
    required this.id,
    required this.deliveryNumber,
    required this.orderNumber,
    required this.shopName,
    this.shopAddress,
    this.itemCount = 0,
    this.totalAmount = 0,
    this.status = DeliveryStatus.pending,
    this.scheduledAt,
    this.lines = const [],
    this.timeline = const [],
    this.receiverName,
    this.proofPhotoBase64,
    this.deliveredAt,
    this.deliveryNotes,
  });

  final String id;

  /// Delivery-side ID shown as the primary reference (e.g. DL-001001).
  final String deliveryNumber;

  /// Linked sales order number (e.g. SO-001245).
  final String orderNumber;
  final String shopName;
  final String? shopAddress;
  final int itemCount;
  final double totalAmount;
  final DeliveryStatus status;
  final DateTime? scheduledAt;
  final List<DmOrderLineModel> lines;
  final List<DmTimelineEventModel> timeline;
  final String? receiverName;
  final String? proofPhotoBase64;
  final DateTime? deliveredAt;
  final String? deliveryNotes;

  int get resolvedItemCount => lines.isNotEmpty ? lines.length : itemCount;

  double get resolvedTotal {
    if (lines.isEmpty) return totalAmount;
    return lines.fold<double>(0, (sum, line) => sum + line.lineTotal);
  }

  DmDeliveryOrderModel copyWith({
    String? id,
    String? deliveryNumber,
    String? orderNumber,
    String? shopName,
    String? shopAddress,
    int? itemCount,
    double? totalAmount,
    DeliveryStatus? status,
    DateTime? scheduledAt,
    List<DmOrderLineModel>? lines,
    List<DmTimelineEventModel>? timeline,
    String? receiverName,
    String? proofPhotoBase64,
    DateTime? deliveredAt,
    String? deliveryNotes,
    bool clearProof = false,
  }) => DmDeliveryOrderModel(
    id: id ?? this.id,
    deliveryNumber: deliveryNumber ?? this.deliveryNumber,
    orderNumber: orderNumber ?? this.orderNumber,
    shopName: shopName ?? this.shopName,
    shopAddress: shopAddress ?? this.shopAddress,
    itemCount: itemCount ?? this.itemCount,
    totalAmount: totalAmount ?? this.totalAmount,
    status: status ?? this.status,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    lines: lines ?? this.lines,
    timeline: timeline ?? this.timeline,
    receiverName: receiverName ?? this.receiverName,
    proofPhotoBase64: clearProof
        ? null
        : (proofPhotoBase64 ?? this.proofPhotoBase64),
    deliveredAt: deliveredAt ?? this.deliveredAt,
    deliveryNotes: deliveryNotes ?? this.deliveryNotes,
  );

  factory DmDeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    final shop = ApiMap.asMap(json['shop']) ?? const <String, dynamic>{};
    final lines = ApiMap.asMapList(
      json['lines'],
    ).map(DmOrderLineModel.fromJson).toList(growable: false);
    final orderNumber =
        ApiMap.asString(json['order_number']) ??
        ApiMap.asString(json['order_id']) ??
        '';
    final deliveryNumber =
        ApiMap.asString(json['delivery_number']) ??
        ApiMap.asString(json['delivery_id']) ??
        (orderNumber.isNotEmpty
            ? orderNumber
            : (ApiMap.asString(json['id']) ?? ''));

    return DmDeliveryOrderModel(
      id: ApiMap.asString(json['id']) ?? '',
      deliveryNumber: deliveryNumber,
      orderNumber: orderNumber,
      shopName:
          ApiMap.asString(json['shop_name']) ??
          ApiMap.asString(shop['name']) ??
          '',
      shopAddress:
          ApiMap.asString(json['shop_address']) ??
          ApiMap.asString(shop['address']),
      itemCount: ApiMap.asInt(json['item_count']) ?? lines.length,
      totalAmount: ApiMap.asDouble(json['total_amount']) ?? 0,
      status: DeliveryStatus.values.firstWhere(
        (s) => s.name == ApiMap.asString(json['status']),
        orElse: () => DeliveryStatus.pending,
      ),
      scheduledAt: ApiMap.asDateTime(json['scheduled_at']),
      lines: lines,
      timeline: ApiMap.asMapList(
        json['timeline'],
      ).map(DmTimelineEventModel.fromJson).toList(growable: false),
      receiverName: ApiMap.asString(json['receiver_name']),
      proofPhotoBase64: ApiMap.asString(json['proof_photo_base64']),
      deliveredAt: ApiMap.asDateTime(json['delivered_at']),
      deliveryNotes: ApiMap.asString(json['delivery_notes']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'delivery_number': deliveryNumber,
    'order_number': orderNumber,
    'shop_name': shopName,
    'shop_address': shopAddress,
    'item_count': resolvedItemCount,
    'total_amount': resolvedTotal,
    'status': status.name,
    'scheduled_at': scheduledAt?.toUtc().toIso8601String(),
    'lines': lines.map((e) => e.toJson()).toList(growable: false),
    'timeline': timeline.map((e) => e.toJson()).toList(growable: false),
    'receiver_name': receiverName,
    'proof_photo_base64': proofPhotoBase64,
    'delivered_at': deliveredAt?.toUtc().toIso8601String(),
    'delivery_notes': deliveryNotes,
  };
}
