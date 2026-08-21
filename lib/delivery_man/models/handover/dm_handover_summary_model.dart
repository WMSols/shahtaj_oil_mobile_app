import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmHandoverSummaryModel {
  const DmHandoverSummaryModel({
    required this.id,
    required this.reference,
    required this.handedAt,
    required this.cashAmount,
    required this.chequeAmount,
    required this.collectionIds,
    this.status = HandoverStatus.completed,
    this.cashierName = '',
    this.notes = '',
  });

  final String id;
  final String reference;
  final DateTime handedAt;
  final double cashAmount;
  final double chequeAmount;
  final List<String> collectionIds;
  final HandoverStatus status;
  final String cashierName;
  final String notes;

  double get total => cashAmount + chequeAmount;
  int get collectionCount => collectionIds.length;

  factory DmHandoverSummaryModel.fromJson(Map<String, dynamic> json) {
    final ids = json['collection_ids'];
    return DmHandoverSummaryModel(
      id: ApiMap.asString(json['id']) ?? '',
      reference: ApiMap.asString(json['reference']) ?? '',
      handedAt: ApiMap.asDateTime(json['handed_at']) ?? DateTime.now(),
      cashAmount: ApiMap.asDouble(json['cash_amount']) ?? 0,
      chequeAmount: ApiMap.asDouble(json['cheque_amount']) ?? 0,
      collectionIds: ids is List
          ? ids.map((id) => id.toString()).toList(growable: false)
          : const [],
      status: HandoverStatusX.fromApi(json['status']),
      cashierName: ApiMap.asString(json['cashier_name']) ?? '',
      notes: ApiMap.asString(json['notes']) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'reference': reference,
    'handed_at': handedAt.toUtc().toIso8601String(),
    'cash_amount': cashAmount,
    'cheque_amount': chequeAmount,
    'collection_ids': collectionIds,
    'status': status.name,
    'cashier_name': cashierName,
    'notes': notes,
  };
}
