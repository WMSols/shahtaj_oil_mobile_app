import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObVisitSummaryModel {
  const ObVisitSummaryModel({
    required this.visitId,
    required this.shopName,
    required this.checkedInAt,
    required this.outcome,
    this.ownerName,
    this.checkedOutAt,
    this.orderId,
    this.orderNumber,
    this.subtotal,
  });

  final int visitId;
  final String shopName;
  final String? ownerName;
  final DateTime checkedInAt;
  final DateTime? checkedOutAt;
  final VisitOutcome outcome;
  final int? orderId;
  final String? orderNumber;
  final double? subtotal;

  factory ObVisitSummaryModel.fromJson(Map<String, dynamic> json) {
    final shop = ApiMap.asMap(json['shop']) ?? const <String, dynamic>{};
    final orderNumber =
        ApiMap.asString(json['order_number']) ??
        ApiMap.asString(json['sale_order_name']);
    return ObVisitSummaryModel(
      visitId: ApiMap.asInt(json['visit_id']) ?? ApiMap.asInt(json['id']) ?? 0,
      shopName:
          ApiMap.asString(json['shop_name']) ??
          ApiMap.asString(shop['name']) ??
          '',
      ownerName:
          ApiMap.asString(json['owner_name']) ??
          ApiMap.asString(shop['owner_name']),
      checkedInAt:
          ApiMap.asDateTime(json['checked_in_at']) ??
          ApiMap.asDateTime(json['started_at']) ??
          DateTime.now(),
      checkedOutAt:
          ApiMap.asDateTime(json['checked_out_at']) ??
          ApiMap.asDateTime(json['ended_at']),
      outcome: parseOutcome(ApiMap.asString(json['outcome'])),
      orderId: ApiMap.asInt(json['order_id']),
      orderNumber: orderNumber,
      subtotal:
          ApiMap.asDouble(json['subtotal']) ??
          ApiMap.asDouble(json['order_amount']),
    );
  }

  static VisitOutcome parseOutcome(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return VisitOutcome.endedWithoutOrder;
    }
    final value = raw.trim().toLowerCase();
    if (value == 'order' || value == 'order_placed' || value == 'orderplaced') {
      return VisitOutcome.orderPlaced;
    }
    if (value == 'skipped' || value == 'skip') {
      return VisitOutcome.skipped;
    }
    if (value == 'no_order' ||
        value == 'no-order' ||
        value == 'ended_without_order' ||
        value == 'endedwithoutorder' ||
        value == 'no_sale') {
      return VisitOutcome.endedWithoutOrder;
    }
    return VisitOutcome.values.firstWhere(
      (outcome) =>
          outcome.name == raw ||
          outcome.name == ApiMap.snakeToCamel(raw) ||
          outcome.name == raw.replaceAll('-', '_'),
      orElse: () => VisitOutcome.endedWithoutOrder,
    );
  }
}

class ObVisitListResult {
  const ObVisitListResult({required this.visits, required this.total});

  final List<ObVisitSummaryModel> visits;
  final int total;

  factory ObVisitListResult.fromJson(Map<String, dynamic> json) {
    final list = ApiMap.listOf(json, 'visits');
    return ObVisitListResult(
      visits: list.map(ObVisitSummaryModel.fromJson).toList(growable: false),
      total: ApiMap.asInt(json['total']) ?? list.length,
    );
  }
}
