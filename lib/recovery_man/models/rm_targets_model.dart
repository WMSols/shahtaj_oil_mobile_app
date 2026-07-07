class RmTargetsModel {
  const RmTargetsModel({this.recoveryCurrent = 0, this.recoveryTarget = 0});

  final double recoveryCurrent;
  final double recoveryTarget;

  factory RmTargetsModel.fromJson(Map<String, dynamic> json) {
    return RmTargetsModel(
      recoveryCurrent: (json['recovery_current'] as num?)?.toDouble() ?? 0,
      recoveryTarget: (json['recovery_target'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recovery_current': recoveryCurrent,
      'recovery_target': recoveryTarget,
    };
  }
}
