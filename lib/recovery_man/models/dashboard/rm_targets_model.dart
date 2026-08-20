import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class RmTargetsModel {
  const RmTargetsModel({this.recoveryCurrent = 0, this.recoveryTarget = 0});

  final double recoveryCurrent;
  final double recoveryTarget;

  factory RmTargetsModel.fromJson(Map<String, dynamic> json) {
    return RmTargetsModel(
      recoveryCurrent: ApiMap.asDouble(json['recovery_current']) ?? 0,
      recoveryTarget: ApiMap.asDouble(json['recovery_target']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recovery_current': recoveryCurrent,
      'recovery_target': recoveryTarget,
    };
  }
}
