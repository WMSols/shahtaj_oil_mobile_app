import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_line_model.dart';

class ObOrderModel {
  const ObOrderModel({
    required this.id,
    required this.shopId,
    this.status = OrderStatus.draft,
    this.lines = const [],
  });

  final String id;
  final String shopId;
  final OrderStatus status;
  final List<ObOrderLineModel> lines;

  factory ObOrderModel.fromJson(Map<String, dynamic> json) => ObOrderModel(
    id: json['id']?.toString() ?? '',
    shopId: json['shop_id']?.toString() ?? '',
    status: OrderStatus.values.firstWhere(
      (s) => s.name == json['status']?.toString(),
      orElse: () => OrderStatus.draft,
    ),
    lines: (json['lines'] as List<dynamic>? ?? [])
        .map((e) => ObOrderLineModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'shop_id': shopId,
    'status': status.name,
    'lines': lines.map((e) => e.toJson()).toList(),
  };
}
