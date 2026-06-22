class DmReturnModel {
  const DmReturnModel({
    required this.id,
    required this.deliveryId,
    this.reason,
  });

  final String id;
  final String deliveryId;
  final String? reason;

  factory DmReturnModel.fromJson(Map<String, dynamic> json) => DmReturnModel(
    id: json['id']?.toString() ?? '',
    deliveryId: json['delivery_id']?.toString() ?? '',
    reason: json['reason']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'delivery_id': deliveryId,
    'reason': reason,
  };
}
