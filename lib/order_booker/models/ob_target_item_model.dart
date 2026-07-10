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
    return ObTargetItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      current: (json['current'] as num?)?.toDouble() ?? 0,
      target: (json['target'] as num?)?.toDouble() ?? 0,
      unit: json['unit']?.toString() ?? '',
    );
  }
}
