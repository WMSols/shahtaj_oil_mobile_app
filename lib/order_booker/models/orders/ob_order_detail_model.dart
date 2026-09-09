import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_approval_info.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_line_model.dart';

class ObOrderDetailModel {
  const ObOrderDetailModel({
    required this.id,
    required this.orderNumber,
    required this.shopId,
    required this.shopName,
    required this.lines,
    required this.subtotal,
    this.createdAt,
    this.visitId,
    this.approval = ObOrderApprovalInfo.empty,
    this.creditWouldExceed = false,
  });

  final String id;
  final String orderNumber;
  final String shopId;
  final String shopName;
  final List<ObOrderLineModel> lines;
  final double subtotal;
  final DateTime? createdAt;
  final int? visitId;
  final ObOrderApprovalInfo approval;
  final bool creditWouldExceed;

  bool get showsApprovalSection =>
      approval.state != ObOrderApprovalState.none ||
      approval.needsVerification ||
      approval.isRejected ||
      approval.isVerified ||
      approval.hasDiscount;

  bool get showsCreditSection => approval.hasCreditReason || creditWouldExceed;

  double get discountTotal =>
      approval.discountAmount ??
      lines.fold<double>(0, (sum, line) {
        if (!line.isDiscounted) return sum;
        return sum + (line.appRate - line.proposedRate) * line.quantity;
      });

  factory ObOrderDetailModel.fromVisitJson(Map<String, dynamic> json) {
    final shop = ApiMap.asMap(json['shop']) ?? const <String, dynamic>{};
    final order = ApiMap.asMap(json['order']);
    final lines = ApiMap.listOf(
      json,
      'lines',
    ).map(ObOrderLineModel.fromJson).toList(growable: false);

    final computedSubtotal = lines.fold<double>(
      0,
      (sum, line) => sum + line.lineTotal,
    );

    final approval = ObOrderApprovalInfo.fromOrderAndVisit(
      order: order,
      visit: json,
    );

    final visitId = ApiMap.asInt(json['visit_id']) ?? ApiMap.asInt(json['id']);
    final orderNumber =
        ApiMap.asString(order?['name']) ??
        ApiMap.asString(json['sale_order_name']) ??
        ApiMap.asString(json['order_number']) ??
        (visitId != null ? 'SO-$visitId' : '');

    return ObOrderDetailModel(
      id:
          ApiMap.asString(order?['id']) ??
          ApiMap.asString(json['order_id']) ??
          orderNumber,
      orderNumber: orderNumber,
      shopId:
          ApiMap.asString(json['shop_id']) ??
          ApiMap.asString(shop['shop_id']) ??
          ApiMap.asString(shop['id']) ??
          '',
      shopName:
          ApiMap.asString(json['shop_name']) ??
          ApiMap.asString(shop['name']) ??
          '',
      lines: lines,
      subtotal:
          approval.amountTotal ??
          ApiMap.asDouble(json['order_amount']) ??
          ApiMap.asDouble(json['subtotal']) ??
          computedSubtotal,
      createdAt:
          ApiMap.asDateTime(order?['verified_at']) ??
          ApiMap.asDateTime(json['ended_at']) ??
          ApiMap.asDateTime(json['started_at']) ??
          ApiMap.asDateTime(json['created_at']),
      visitId: visitId,
      approval: approval,
      creditWouldExceed: shop['credit_would_exceed'] == true,
    );
  }

  factory ObOrderDetailModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('sale_order_name') ||
        json.containsKey('order_amount') ||
        json['shop'] is Map ||
        json['order'] is Map) {
      return ObOrderDetailModel.fromVisitJson(json);
    }

    final lines = ApiMap.listOf(
      json,
      'lines',
    ).map(ObOrderLineModel.fromJson).toList(growable: false);

    final subtotal = lines.fold<double>(0, (sum, line) => sum + line.lineTotal);
    final approval = ObOrderApprovalInfo.fromOrderAndVisit(
      order: json,
      visit: json,
    );

    return ObOrderDetailModel(
      id: ApiMap.asString(json['id']) ?? '',
      orderNumber:
          ApiMap.asString(json['order_number']) ??
          ApiMap.asString(json['name']) ??
          '',
      shopId: ApiMap.asString(json['shop_id']) ?? '',
      shopName: ApiMap.asString(json['shop_name']) ?? '',
      lines: lines,
      subtotal:
          ApiMap.asDouble(json['subtotal']) ??
          ApiMap.asDouble(json['amount_total']) ??
          subtotal,
      createdAt: ApiMap.asDateTime(json['created_at']),
      visitId: ApiMap.asInt(json['visit_id']),
      approval: approval,
      creditWouldExceed: json['credit_would_exceed'] == true,
    );
  }
}
