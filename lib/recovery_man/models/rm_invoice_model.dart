import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class RmInvoiceModel {
  const RmInvoiceModel({
    required this.id,
    required this.shopId,
    required this.amount,
    this.status = CollectionStatus.pending,
  });

  final String id;
  final String shopId;
  final double amount;
  final CollectionStatus status;

  factory RmInvoiceModel.fromJson(Map<String, dynamic> json) => RmInvoiceModel(
    id: json['id']?.toString() ?? '',
    shopId: json['shop_id']?.toString() ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 0,
    status: CollectionStatus.values.firstWhere(
      (s) => s.name == json['status']?.toString(),
      orElse: () => CollectionStatus.pending,
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'shop_id': shopId,
    'amount': amount,
    'status': status.name,
  };
}
