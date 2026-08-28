import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmTargetsModel {
  const DmTargetsModel({
    this.deliveryCurrent = 0,
    this.deliveryTarget = 0,
    this.deliveryValueCurrent = 0,
    this.deliveryValueTarget = 0,
    this.recoveryCurrent = 0,
    this.recoveryTarget = 0,
  });

  final int deliveryCurrent;
  final int deliveryTarget;
  final double deliveryValueCurrent;
  final double deliveryValueTarget;
  final double recoveryCurrent;
  final double recoveryTarget;

  double get deliveryProgress =>
      deliveryTarget <= 0 ? 0 : deliveryCurrent / deliveryTarget;

  double get recoveryProgress =>
      recoveryTarget <= 0 ? 0 : recoveryCurrent / recoveryTarget;

  int get deliveryPercent => (deliveryProgress * 100).clamp(0, 100).round();

  int get recoveryPercent => (recoveryProgress * 100).clamp(0, 100).round();

  bool get hasAnyTarget => deliveryTarget > 0 || recoveryTarget > 0;

  DmTargetsModel copyWith({
    int? deliveryCurrent,
    int? deliveryTarget,
    double? deliveryValueCurrent,
    double? deliveryValueTarget,
    double? recoveryCurrent,
    double? recoveryTarget,
  }) {
    return DmTargetsModel(
      deliveryCurrent: deliveryCurrent ?? this.deliveryCurrent,
      deliveryTarget: deliveryTarget ?? this.deliveryTarget,
      deliveryValueCurrent: deliveryValueCurrent ?? this.deliveryValueCurrent,
      deliveryValueTarget: deliveryValueTarget ?? this.deliveryValueTarget,
      recoveryCurrent: recoveryCurrent ?? this.recoveryCurrent,
      recoveryTarget: recoveryTarget ?? this.recoveryTarget,
    );
  }

  factory DmTargetsModel.fromJson(Map<String, dynamic> json) {
    return DmTargetsModel(
      deliveryCurrent: ApiMap.asInt(json['delivery_current']) ?? 0,
      deliveryTarget: ApiMap.asInt(json['delivery_target']) ?? 0,
      deliveryValueCurrent:
          ApiMap.asDouble(json['delivery_value_current']) ?? 0,
      deliveryValueTarget: ApiMap.asDouble(json['delivery_value_target']) ?? 0,
      recoveryCurrent: ApiMap.asDouble(json['recovery_current']) ?? 0,
      recoveryTarget: ApiMap.asDouble(json['recovery_target']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delivery_current': deliveryCurrent,
      'delivery_target': deliveryTarget,
      'delivery_value_current': deliveryValueCurrent,
      'delivery_value_target': deliveryValueTarget,
      'recovery_current': recoveryCurrent,
      'recovery_target': recoveryTarget,
    };
  }
}
