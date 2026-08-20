import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class RmCollectionLineModel {
  const RmCollectionLineModel({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.amount,
  });

  final String invoiceId;
  final String invoiceNumber;
  final double amount;

  factory RmCollectionLineModel.fromJson(Map<String, dynamic> json) {
    return RmCollectionLineModel(
      invoiceId: ApiMap.asString(json['invoice_id']) ?? '',
      invoiceNumber: ApiMap.asString(json['invoice_number']) ?? '',
      amount: ApiMap.asDouble(json['amount']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'invoice_id': invoiceId,
    'invoice_number': invoiceNumber,
    'amount': amount,
  };
}
