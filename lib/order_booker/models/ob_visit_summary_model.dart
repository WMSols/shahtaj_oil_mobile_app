import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class ObVisitSummaryModel {
  const ObVisitSummaryModel({
    required this.visitId,
    required this.shopName,
    required this.checkedInAt,
    required this.outcome,
    this.ownerName,
    this.checkedOutAt,
    this.orderId,
    this.orderNumber,
    this.subtotal,
  });

  final int visitId;
  final String shopName;
  final String? ownerName;
  final DateTime checkedInAt;
  final DateTime? checkedOutAt;
  final VisitOutcome outcome;
  final int? orderId;
  final String? orderNumber;
  final double? subtotal;

  factory ObVisitSummaryModel.fromJson(Map<String, dynamic> json) =>
      ObVisitSummaryModel(
        visitId: (json['visit_id'] as num?)?.toInt() ?? 0,
        shopName: json['shop_name']?.toString() ?? '',
        ownerName: json['owner_name']?.toString(),
        checkedInAt:
            DateTime.tryParse(json['checked_in_at']?.toString() ?? '') ??
            DateTime.now(),
        checkedOutAt: json['checked_out_at'] != null
            ? DateTime.tryParse(json['checked_out_at'].toString())
            : null,
        outcome: parseOutcome(json['outcome']?.toString()),
        orderId: (json['order_id'] as num?)?.toInt(),
        orderNumber: json['order_number']?.toString(),
        subtotal: (json['subtotal'] as num?)?.toDouble(),
      );

  static VisitOutcome parseOutcome(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return VisitOutcome.endedWithoutOrder;
    }
    final value = raw.trim();
    return VisitOutcome.values.firstWhere(
      (outcome) =>
          outcome.name == value ||
          outcome.name == _snakeToCamel(value) ||
          outcome.name == value.replaceAll('-', '_'),
      orElse: () => VisitOutcome.endedWithoutOrder,
    );
  }

  static String _snakeToCamel(String value) {
    final parts = value.split('_');
    if (parts.isEmpty) return value;
    return parts.first +
        parts.skip(1).map((part) {
          if (part.isEmpty) return part;
          return part[0].toUpperCase() + part.substring(1);
        }).join();
  }
}

class ObVisitListResult {
  const ObVisitListResult({required this.visits, required this.total});

  final List<ObVisitSummaryModel> visits;
  final int total;

  factory ObVisitListResult.fromJson(Map<String, dynamic> json) {
    final list = json['visits'] as List<dynamic>? ?? const [];
    return ObVisitListResult(
      visits: list
          .map(
            (item) =>
                ObVisitSummaryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? list.length,
    );
  }
}
