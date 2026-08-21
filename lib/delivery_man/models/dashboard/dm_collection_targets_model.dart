import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmCollectionTargetsModel {
  const DmCollectionTargetsModel({
    this.recoveryCurrent = 0,
    this.recoveryTarget = 0,
  });

  final double recoveryCurrent;
  final double recoveryTarget;

  factory DmCollectionTargetsModel.fromJson(Map<String, dynamic> json) {
    return DmCollectionTargetsModel(
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
