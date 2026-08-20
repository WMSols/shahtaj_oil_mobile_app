import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmTimelineEventModel {
  const DmTimelineEventModel({
    required this.id,
    required this.title,
    required this.at,
    this.note,
  });

  final String id;
  final String title;
  final DateTime at;
  final String? note;

  factory DmTimelineEventModel.fromJson(Map<String, dynamic> json) =>
      DmTimelineEventModel(
        id: ApiMap.asString(json['id']) ?? '',
        title: ApiMap.asString(json['title']) ?? '',
        at: ApiMap.asDateTime(json['at']) ?? DateTime.now(),
        note: ApiMap.asString(json['note']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'at': at.toUtc().toIso8601String(),
    'note': note,
  };
}
