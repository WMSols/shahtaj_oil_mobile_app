import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
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

  bool get hasOrder =>
      outcome == VisitOutcome.orderPlaced &&
      (orderId != null || (orderNumber != null && orderNumber!.isNotEmpty));

  factory ObVisitDetailModel.fromJson(Map<String, dynamic> json) {
    final shop = ApiMap.asMap(json['shop']) ?? const <String, dynamic>{};
    final linesJson = ApiMap.listOf(json, 'lines');
    return ObVisitDetailModel(
      visitId: ApiMap.asInt(json['visit_id']) ?? ApiMap.asInt(json['id']) ?? 0,
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
      shopPhone:
          ApiMap.asString(json['shop_phone']) ??
          ApiMap.asString(shop['owner_phone']),
      locationLabel: ApiMap.asString(json['location_label']),
      checkedInAt:
          ApiMap.asDateTime(json['checked_in_at']) ??
          ApiMap.asDateTime(json['started_at']) ??
          DateTime.now(),
      checkedOutAt:
          ApiMap.asDateTime(json['checked_out_at']) ??
          ApiMap.asDateTime(json['ended_at']),
      outcome: ObVisitSummaryModel.parseOutcome(
        ApiMap.asString(json['outcome']),
      ),
      notes: ApiMap.asString(json['notes']),
      lines: linesJson
          .map(ObVisitCartLineModel.fromJson)
          .toList(growable: false),
      subtotal:
          ApiMap.asDouble(json['subtotal']) ??
          ApiMap.asDouble(json['order_amount']) ??
          0,
      orderId: ApiMap.asInt(json['order_id']),
      orderNumber:
          ApiMap.asString(json['order_number']) ??
          ApiMap.asString(json['sale_order_name']),
      latitude:
          ApiMap.asDouble(json['latitude']) ??
          ApiMap.asDouble(shop['latitude']),
      longitude:
          ApiMap.asDouble(json['longitude']) ??
          ApiMap.asDouble(shop['longitude']),
    );
  }
}
