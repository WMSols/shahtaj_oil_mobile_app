import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';

class ObVisitDetailModel {
  const ObVisitDetailModel({
    required this.visitId,
    required this.shopId,
    required this.shopName,
    required this.checkedInAt,
    required this.outcome,
    this.ownerName,
    this.shopPhone,
    this.locationLabel,
    this.checkedOutAt,
    this.notes,
    this.lines = const [],
    this.subtotal = 0,
    this.orderId,
    this.orderNumber,
    this.latitude,
    this.longitude,
  });

  final int visitId;
  final String shopId;
  final String shopName;
  final String? ownerName;
  final String? shopPhone;
  final String? locationLabel;
  final DateTime checkedInAt;
  final DateTime? checkedOutAt;
  final VisitOutcome outcome;
  final String? notes;
  final List<ObVisitCartLineModel> lines;
  final double subtotal;
  final int? orderId;
  final String? orderNumber;
  final double? latitude;
  final double? longitude;

  bool get hasOrder => outcome == VisitOutcome.orderPlaced && orderId != null;

  factory ObVisitDetailModel.fromJson(Map<String, dynamic> json) {
    final linesJson = json['lines'] as List<dynamic>? ?? const [];
    return ObVisitDetailModel(
      visitId: (json['visit_id'] as num?)?.toInt() ?? 0,
      shopId: json['shop_id']?.toString() ?? '',
      shopName: json['shop_name']?.toString() ?? '',
      ownerName: json['owner_name']?.toString(),
      shopPhone: json['shop_phone']?.toString(),
      locationLabel: json['location_label']?.toString(),
      checkedInAt:
          DateTime.tryParse(json['checked_in_at']?.toString() ?? '') ??
          DateTime.now(),
      checkedOutAt: json['checked_out_at'] != null
          ? DateTime.tryParse(json['checked_out_at'].toString())
          : null,
      outcome: ObVisitSummaryModel.parseOutcome(json['outcome']?.toString()),
      notes: json['notes']?.toString(),
      lines: linesJson
          .map(
            (item) =>
                ObVisitCartLineModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      orderId: (json['order_id'] as num?)?.toInt(),
      orderNumber: json['order_number']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
