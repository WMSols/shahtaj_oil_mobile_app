class ObTargetsModel {
  const ObTargetsModel({this.ordersCurrent = 0, this.ordersTarget = 0});

  final int ordersCurrent;
  final int ordersTarget;

  factory ObTargetsModel.fromJson(Map<String, dynamic> json) {
    return ObTargetsModel(
      ordersCurrent: (json['orders_current'] as num?)?.toInt() ?? 0,
      ordersTarget: (json['orders_target'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'orders_current': ordersCurrent, 'orders_target': ordersTarget};
  }
}
