class DmPickupModel {
  const DmPickupModel({required this.id, required this.deliveryId});

  final String id;
  final String deliveryId;

  factory DmPickupModel.fromJson(Map<String, dynamic> json) => DmPickupModel(
    id: json['id']?.toString() ?? '',
    deliveryId: json['delivery_id']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'delivery_id': deliveryId};
}
