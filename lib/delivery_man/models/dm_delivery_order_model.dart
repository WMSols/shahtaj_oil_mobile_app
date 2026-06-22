import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class DmDeliveryOrderModel {
  const DmDeliveryOrderModel({
    required this.id,
    required this.orderId,
    this.status = DeliveryStatus.pending,
  });

  final String id;
  final String orderId;
  final DeliveryStatus status;

  factory DmDeliveryOrderModel.fromJson(Map<String, dynamic> json) =>
      DmDeliveryOrderModel(
        id: json['id']?.toString() ?? '',
        orderId: json['order_id']?.toString() ?? '',
        status: DeliveryStatus.values.firstWhere(
          (s) => s.name == json['status']?.toString(),
          orElse: () => DeliveryStatus.pending,
        ),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_id': orderId,
    'status': status.name,
  };
}
