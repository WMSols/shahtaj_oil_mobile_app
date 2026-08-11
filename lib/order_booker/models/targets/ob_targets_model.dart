import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_target_item_model.dart';

class ObTargetsModel {
  const ObTargetsModel({
    this.headlinePercent = 0,
    this.topHighlights = const [],
  });

  /// Average headline progress across active targets (0–100).
  final int headlinePercent;
  final List<ObTargetHighlight> topHighlights;

  factory ObTargetsModel.fromTargets(List<ObTargetItemModel> items) {
    if (items.isEmpty) return const ObTargetsModel();
    final sum = items.fold<double>(
      0,
      (total, item) => total + item.headlineProgress,
    );
    final highlights = items
        .map(
          (item) => ObTargetHighlight(
            title: item.displayTitle,
            percent: item.headlinePercentRounded.clamp(0, 100),
            current: item.current,
            target: item.target,
            unit: item.unit,
          ),
        )
        .toList(growable: false);
    highlights.sort((a, b) => b.percent.compareTo(a.percent));
    return ObTargetsModel(
      headlinePercent: ((sum / items.length) * 100).round().clamp(0, 100),
      topHighlights: highlights.take(2).toList(growable: false),
    );
  }

  factory ObTargetsModel.fromJson(Map<String, dynamic> json) {
    return ObTargetsModel(
      headlinePercent: (json['headline_percent'] as num?)?.toInt() ?? 0,
      topHighlights: (json['top_highlights'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((e) => ObTargetHighlight.fromJson(Map<String, dynamic>.from(e)))
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headline_percent': headlinePercent,
      'top_highlights': topHighlights.map((e) => e.toJson()).toList(),
    };
  }
}

class ObTargetHighlight {
  const ObTargetHighlight({
    required this.title,
    required this.percent,
    this.current,
    this.target,
    this.unit = '',
  });

  final String title;
  final int percent;
  final double? current;
  final double? target;
  final String unit;

  bool get hasAbsolute =>
      current != null && target != null && (target ?? 0) > 0;

  String get absoluteLabel {
    if (!hasAbsolute) return '';
    return AppFormatter.targetProgressValues(
      current: current!,
      target: target!,
      unit: unit,
    );
  }

  /// e.g. `Title • 12 / 50 kg (24%)`
  String get dashboardLine {
    final abs = absoluteLabel;
    if (abs.isNotEmpty) return '$title • $abs ($percent%)';
    return '$title • $percent%';
  }

  factory ObTargetHighlight.fromJson(Map<String, dynamic> json) {
    return ObTargetHighlight(
      title: json['title']?.toString() ?? '',
      percent: (json['percent'] as num?)?.toInt() ?? 0,
      current: (json['current'] as num?)?.toDouble(),
      target: (json['target'] as num?)?.toDouble(),
      unit: json['unit']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'percent': percent,
    if (current != null) 'current': current,
    if (target != null) 'target': target,
    if (unit.isNotEmpty) 'unit': unit,
  };
}
