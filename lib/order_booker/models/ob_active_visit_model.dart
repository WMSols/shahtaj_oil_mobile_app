import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObActiveVisitModel {
  const ObActiveVisitModel({
    required this.visitId,
    required this.taskId,
    required this.shopId,
    required this.shopName,
    this.checkedInAt,
    this.latitude,
    this.longitude,
  });

  final int visitId;
  final int taskId;
  final String shopId;
  final String shopName;
  final DateTime? checkedInAt;
  final double? latitude;
  final double? longitude;

  factory ObActiveVisitModel.fromJson(Map<String, dynamic> json) {
    final shop = ApiMap.asMap(json['shop']) ?? const <String, dynamic>{};
    return ObActiveVisitModel(
      visitId: ApiMap.asInt(json['visit_id']) ?? ApiMap.asInt(json['id']) ?? 0,
      taskId: ApiMap.asInt(json['task_id']) ?? 0,
      shopId:
          ApiMap.asString(json['shop_id']) ??
          ApiMap.asString(shop['shop_id']) ??
          ApiMap.asString(shop['id']) ??
          '',
      shopName:
          ApiMap.asString(json['shop_name']) ??
          ApiMap.asString(shop['name']) ??
          '',
      checkedInAt:
          ApiMap.asDateTime(json['checked_in_at']) ??
          ApiMap.asDateTime(json['started_at']),
      latitude:
          ApiMap.asDouble(json['latitude']) ??
          ApiMap.asDouble(shop['latitude']),
      longitude:
          ApiMap.asDouble(json['longitude']) ??
          ApiMap.asDouble(shop['longitude']),
    );
  }

  Map<String, dynamic> toJson() => {
    'visit_id': visitId,
    'task_id': taskId,
    'shop_id': shopId,
    'shop_name': shopName,
    'checked_in_at': checkedInAt?.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
  };
}
