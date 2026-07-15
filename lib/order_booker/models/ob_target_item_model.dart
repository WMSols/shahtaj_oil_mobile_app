import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ObTargetItemModel {
  const ObTargetItemModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.current,
    required this.target,
    this.unit = '',
  });

  final String id;
  final String title;
  final String? subtitle;
  final double current;
  final double target;
  final String unit;

  double get progress => target <= 0 ? 0 : (current / target).clamp(0, 1);

  factory ObTargetItemModel.fromJson(Map<String, dynamic> json) {
    final product = ApiMap.asMap(json['product']);
    final dateStart = ApiMap.asString(json['date_start']);
    final dateEnd = ApiMap.asString(json['date_end']);
    final range = (dateStart != null && dateEnd != null)
        ? '$dateStart → $dateEnd'
        : dateStart ?? dateEnd;

    return ObTargetItemModel(
      id: ApiMap.asString(json['id']) ?? '',
      title:
          ApiMap.asString(json['title']) ?? ApiMap.asString(json['name']) ?? '',
      subtitle:
          ApiMap.asString(json['subtitle']) ??
          ApiMap.asString(product?['name']) ??
          range,
      current:
          ApiMap.asDouble(json['current']) ??
          ApiMap.asDouble(json['achieved_value']) ??
          0,
      target:
          ApiMap.asDouble(json['target']) ??
          ApiMap.asDouble(json['target_value']) ??
          0,
      unit:
          ApiMap.asString(json['unit']) ??
          ApiMap.asString(json['target_weight_uom']) ??
          ApiMap.asString(json['weight_unit_label']) ??
          '',
    );
  }
}
