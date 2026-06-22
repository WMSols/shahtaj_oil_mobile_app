import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class RmHandoverModel {
  const RmHandoverModel({
    required this.id,
    required this.totalAmount,
    this.status = CollectionStatus.handedOver,
  });

  final String id;
  final double totalAmount;
  final CollectionStatus status;

  factory RmHandoverModel.fromJson(Map<String, dynamic> json) => RmHandoverModel(
    id: json['id']?.toString() ?? '',
    totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
    status: CollectionStatus.values.firstWhere(
      (s) => s.name == json['status']?.toString(),
      orElse: () => CollectionStatus.handedOver,
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'total_amount': totalAmount,
    'status': status.name,
  };
}
