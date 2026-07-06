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

  factory ObActiveVisitModel.fromJson(Map<String, dynamic> json) =>
      ObActiveVisitModel(
        visitId: (json['visit_id'] as num?)?.toInt() ?? 0,
        taskId: (json['task_id'] as num?)?.toInt() ?? 0,
        shopId: json['shop_id']?.toString() ?? '',
        shopName: json['shop_name']?.toString() ?? '',
        checkedInAt: json['checked_in_at'] != null
            ? DateTime.tryParse(json['checked_in_at'].toString())
            : null,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );

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
