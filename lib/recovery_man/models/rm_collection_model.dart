import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class RmCollectionModel {
  const RmCollectionModel({
    required this.id,
    required this.invoiceId,
    required this.amount,
    this.status = CollectionStatus.collected,
  });

  final String id;
  final String invoiceId;
  final double amount;
  final CollectionStatus status;

  factory RmCollectionModel.fromJson(Map<String, dynamic> json) =>
      RmCollectionModel(
        id: json['id']?.toString() ?? '',
        invoiceId: json['invoice_id']?.toString() ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        status: CollectionStatus.values.firstWhere(
          (s) => s.name == json['status']?.toString(),
          orElse: () => CollectionStatus.collected,
        ),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice_id': invoiceId,
    'amount': amount,
    'status': status.name,
  };
}
