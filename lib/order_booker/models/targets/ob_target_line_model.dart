import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';

/// Per-product line inside a [ObTargetType.combinedProduct] target.
class ObTargetLineModel {
  const ObTargetLineModel({
    required this.productId,
    required this.productName,
    required this.current,
    required this.target,
    this.unit = '',
    this.measure = '',
    this.progressPercent,
  });

  final String productId;
  final String productName;
  final double current;
  final double target;
  final String unit;
  final String measure;
  final double? progressPercent;

  double get progress {
    if (progressPercent != null) {
      return (progressPercent! / 100).clamp(0, 1);
    }
    if (target <= 0) return 0;
    return (current / target).clamp(0, 1);
  }

  int get progressPercentRounded => (progress * 100).round();

  String get displayProductName => AppFormatter.displayLabel(productName);

  factory ObTargetLineModel.fromJson(Map<String, dynamic> json) {
    final product = ApiMap.asMap(json['product']);
    return ObTargetLineModel(
      productId:
          ApiMap.asString(json['product_id']) ??
          ApiMap.asString(product?['id']) ??
          '',
      productName:
          ApiMap.asString(json['product_name']) ??
          ApiMap.asString(product?['name']) ??
          '',
      current:
          ApiMap.asDouble(json['achieved_value']) ??
          ApiMap.asDouble(json['current']) ??
          0,
      target:
          ApiMap.asDouble(json['target_value']) ??
          ApiMap.asDouble(json['target']) ??
          0,
      unit:
          ApiMap.asString(json['weight_unit_label']) ??
          ApiMap.asString(json['target_weight_uom']) ??
          ApiMap.asString(json['unit']) ??
          '',
      measure:
          ApiMap.asString(json['measure_type']) ??
          ApiMap.asString(json['measure']) ??
          '',
      progressPercent: ApiMap.asDouble(json['progress_percent']),
    );
  }
}
