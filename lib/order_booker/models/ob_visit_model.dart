import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class ObVisitModel {
  const ObVisitModel({
    required this.id,
    required this.shopId,
    this.checkInAt,
    this.checkOutAt,
    this.status = VisitStatus.checkedIn,
  });

  final String id;
  final String shopId;
  final DateTime? checkInAt;
  final DateTime? checkOutAt;
  final VisitStatus status;

  factory ObVisitModel.fromJson(Map<String, dynamic> json) => ObVisitModel(
    id: json['id']?.toString() ?? '',
    shopId: json['shop_id']?.toString() ?? '',
    checkInAt: json['check_in_at'] != null
        ? DateTime.tryParse(json['check_in_at'].toString())
        : null,
    checkOutAt: json['check_out_at'] != null
        ? DateTime.tryParse(json['check_out_at'].toString())
        : null,
    status: VisitStatus.values.firstWhere(
      (s) => s.name == json['status']?.toString(),
      orElse: () => VisitStatus.checkedIn,
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'shop_id': shopId,
    'check_in_at': checkInAt?.toIso8601String(),
    'check_out_at': checkOutAt?.toIso8601String(),
    'status': status.name,
  };
}
