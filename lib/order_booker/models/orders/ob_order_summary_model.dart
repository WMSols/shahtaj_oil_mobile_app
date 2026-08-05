import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class ObOrderSummaryModel {
  const ObOrderSummaryModel({
    required this.id,
    required this.orderNumber,
    required this.shopName,
    required this.amount,
    this.status = OrderStatus.draft,
  });

  final String id;
  final String orderNumber;
  final String shopName;
  final double amount;
  final OrderStatus status;

  factory ObOrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return ObOrderSummaryModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? '',
      shopName: json['shop_name']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status']?.toString(),
        orElse: () => OrderStatus.draft,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'shop_name': shopName,
      'amount': amount,
      'status': status.name,
    };
  }
}
