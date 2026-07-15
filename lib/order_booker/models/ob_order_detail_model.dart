import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_line_model.dart';

class ObOrderDetailModel {
  const ObOrderDetailModel({
    required this.id,
    required this.orderNumber,
    required this.shopId,
    required this.shopName,
    required this.status,
    required this.lines,
    required this.subtotal,
    this.createdAt,
    this.visitId,
  });

  final String id;
  final String orderNumber;
  final String shopId;
  final String shopName;
  final OrderStatus status;
  final List<ObOrderLineModel> lines;
  final double subtotal;
  final DateTime? createdAt;
  final int? visitId;

  /// Maps a `visits/get` visit payload (order lives on the visit).
  factory ObOrderDetailModel.fromVisitJson(Map<String, dynamic> json) {
    final shop = ApiMap.asMap(json['shop']) ?? const <String, dynamic>{};
    final lines = ApiMap.listOf(
      json,
      'lines',
    ).map(ObOrderLineModel.fromJson).toList(growable: false);

    final computedSubtotal = lines.fold<double>(
      0,
      (sum, line) => sum + line.lineTotal,
    );

    final visitId = ApiMap.asInt(json['visit_id']) ?? ApiMap.asInt(json['id']);
    final orderNumber =
        ApiMap.asString(json['sale_order_name']) ??
        ApiMap.asString(json['order_number']) ??
        (visitId != null ? 'SO-$visitId' : '');

    return ObOrderDetailModel(
      id: ApiMap.asString(json['order_id']) ?? orderNumber,
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
      status: _statusFromVisit(json),
      lines: lines,
      subtotal:
          ApiMap.asDouble(json['order_amount']) ??
          ApiMap.asDouble(json['subtotal']) ??
          computedSubtotal,
      createdAt:
          ApiMap.asDateTime(json['ended_at']) ??
          ApiMap.asDateTime(json['started_at']) ??
          ApiMap.asDateTime(json['created_at']),
      visitId: visitId,
    );
  }

  factory ObOrderDetailModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('sale_order_name') ||
        json.containsKey('order_amount') ||
        (json['shop'] is Map)) {
      return ObOrderDetailModel.fromVisitJson(json);
    }

    final lines = ApiMap.listOf(
      json,
      'lines',
    ).map(ObOrderLineModel.fromJson).toList(growable: false);

    final subtotal = lines.fold<double>(0, (sum, line) => sum + line.lineTotal);

    return ObOrderDetailModel(
      id: ApiMap.asString(json['id']) ?? '',
      orderNumber: ApiMap.asString(json['order_number']) ?? '',
      shopId: ApiMap.asString(json['shop_id']) ?? '',
      shopName: ApiMap.asString(json['shop_name']) ?? '',
      status: OrderStatus.values.firstWhere(
        (value) => value.name == json['status']?.toString(),
        orElse: () => OrderStatus.submitted,
      ),
      lines: lines,
      subtotal: ApiMap.asDouble(json['subtotal']) ?? subtotal,
      createdAt: ApiMap.asDateTime(json['created_at']),
      visitId: ApiMap.asInt(json['visit_id']),
    );
  }

  static OrderStatus _statusFromVisit(Map<String, dynamic> json) {
    final state = ApiMap.asString(json['state'])?.toLowerCase();
    if (state == 'completed') return OrderStatus.submitted;
    if (state == 'cancelled') return OrderStatus.cancelled;
    return OrderStatus.submitted;
  }
}
