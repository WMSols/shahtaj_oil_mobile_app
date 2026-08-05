import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_target_item_model.dart';

class ObTargetsModel {
  const ObTargetsModel({this.headlinePercent = 0});

  /// Average headline progress across active targets (0–100).
  final int headlinePercent;

  factory ObTargetsModel.fromTargets(List<ObTargetItemModel> items) {
    if (items.isEmpty) return const ObTargetsModel();
    final sum = items.fold<double>(
      0,
      (total, item) => total + item.headlineProgress,
    );
    return ObTargetsModel(
      headlinePercent: ((sum / items.length) * 100).round().clamp(0, 100),
    );
  }

  factory ObTargetsModel.fromJson(Map<String, dynamic> json) {
    return ObTargetsModel(
      headlinePercent: (json['headline_percent'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'headline_percent': headlinePercent};
  }
}
