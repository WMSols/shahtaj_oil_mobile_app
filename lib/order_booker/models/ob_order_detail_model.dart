import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
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

  factory ObOrderDetailModel.fromJson(Map<String, dynamic> json) {
    final lines = (json['lines'] as List<dynamic>? ?? const [])
        .map((item) => ObOrderLineModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final subtotal = lines.fold<double>(
      0,
      (sum, line) => sum + (line.quantity * line.unitPrice),
    );

    return ObOrderDetailModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? '',
      shopId: json['shop_id']?.toString() ?? '',
      shopName: json['shop_name']?.toString() ?? '',
      status: OrderStatus.values.firstWhere(
        (value) => value.name == json['status']?.toString(),
        orElse: () => OrderStatus.submitted,
      ),
      lines: lines,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? subtotal,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      visitId: (json['visit_id'] as num?)?.toInt(),
    );
  }
}
