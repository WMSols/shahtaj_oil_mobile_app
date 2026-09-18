import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmSessionModel {
  const DmSessionModel({
    required this.id,
    required this.state,
    this.date,
    this.departedAt,
    this.endedAt,
  });

  final int id;
  final DmSessionState state;
  final DateTime? date;
  final DateTime? departedAt;
  final DateTime? endedAt;

  bool get isOffice => state == DmSessionState.office;
  bool get isOnTheWay => state == DmSessionState.onTheWay;
  bool get isEnded => state == DmSessionState.ended;

  factory DmSessionModel.fromJson(Map<String, dynamic> json) {
    return DmSessionModel(
      id: ApiMap.asInt(json['id']) ?? 0,
      state:
          DmSessionStateX.tryParse(ApiMap.asString(json['state'])) ??
          DmSessionState.office,
      date: ApiMap.asDateTime(json['date']),
      departedAt: ApiMap.asDateTime(json['departed_at']),
      endedAt: ApiMap.asDateTime(json['ended_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'state': switch (state) {
      DmSessionState.office => 'office',
      DmSessionState.onTheWay => 'on_the_way',
      DmSessionState.ended => 'ended',
    },
    'date': date?.toIso8601String(),
    'departed_at': departedAt?.toIso8601String(),
    'ended_at': endedAt?.toIso8601String(),
  };
}
