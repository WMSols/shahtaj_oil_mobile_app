import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmInvoiceModel {
  const DmInvoiceModel({
    required this.id,
    required this.shopId,
    required this.invoiceNumber,
    required this.issuedAt,
    required this.originalAmount,
    required this.remainingAmount,
  });

  final String id;
  final String shopId;
  final String invoiceNumber;
  final DateTime issuedAt;
  final double originalAmount;
  final double remainingAmount;

  bool get isSettled => remainingAmount <= 0;

  factory DmInvoiceModel.fromJson(Map<String, dynamic> json) {
    return DmInvoiceModel(
      id: ApiMap.asString(json['id']) ?? '',
      shopId: ApiMap.asString(json['shop_id']) ?? '',
      invoiceNumber: ApiMap.asString(json['invoice_number']) ?? '',
      issuedAt: ApiMap.asDateTime(json['issued_at']) ?? DateTime.now(),
      originalAmount: ApiMap.asDouble(json['original_amount']) ?? 0,
      remainingAmount: ApiMap.asDouble(json['remaining_amount']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_id': shopId,
      'invoice_number': invoiceNumber,
      'issued_at': issuedAt.toUtc().toIso8601String(),
      'original_amount': originalAmount,
      'remaining_amount': remainingAmount,
    };
  }

  DmInvoiceModel copyWith({double? remainingAmount}) {
    return DmInvoiceModel(
      id: id,
      shopId: shopId,
      invoiceNumber: invoiceNumber,
      issuedAt: issuedAt,
      originalAmount: originalAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
    );
  }
}
