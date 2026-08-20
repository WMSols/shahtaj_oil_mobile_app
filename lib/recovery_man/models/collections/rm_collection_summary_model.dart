import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_line_model.dart';

class RmCollectionSummaryModel {
  const RmCollectionSummaryModel({
    required this.id,
    required this.receiptNumber,
    required this.shopId,
    required this.shopName,
    required this.amount,
    required this.collectedAt,
    this.method = PaymentMethod.cash,
    this.mode = CollectionMode.invoiceWise,
    this.status = CollectionStatus.collected,
    this.notes = '',
    this.reference = '',
    this.proofPhotoBase64,
    this.handoverId,
    this.lines = const [],
  });

  final String id;
  final String receiptNumber;
  final String shopId;
  final String shopName;
  final double amount;
  final DateTime collectedAt;
  final PaymentMethod method;
  final CollectionMode mode;
  final CollectionStatus status;
  final String notes;
  final String reference;
  final String? proofPhotoBase64;
  final String? handoverId;
  final List<RmCollectionLineModel> lines;

  bool get isInBag =>
      status == CollectionStatus.collected && method != PaymentMethod.bank;

  bool get isUnallocatedBatch => mode == CollectionMode.batch && lines.isEmpty;

  factory RmCollectionSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawLines = json['lines'];
    return RmCollectionSummaryModel(
      id: ApiMap.asString(json['id']) ?? '',
      receiptNumber: ApiMap.asString(json['receipt_number']) ?? '',
      shopId: ApiMap.asString(json['shop_id']) ?? '',
      shopName: ApiMap.asString(json['shop_name']) ?? '',
      amount: ApiMap.asDouble(json['amount']) ?? 0,
      collectedAt: ApiMap.asDateTime(json['collected_at']) ?? DateTime.now(),
      method: PaymentMethodX.fromApi(json['method']),
      mode: CollectionModeX.fromApi(json['mode']),
      status: CollectionStatusX.fromApi(json['status']),
      notes: ApiMap.asString(json['notes']) ?? '',
      reference: ApiMap.asString(json['reference']) ?? '',
      proofPhotoBase64: ApiMap.asString(json['proof_photo_base64']),
      handoverId: ApiMap.asString(json['handover_id']),
      lines: rawLines is List
          ? rawLines
                .whereType<Map>()
                .map(
                  (item) => RmCollectionLineModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receipt_number': receiptNumber,
      'shop_id': shopId,
      'shop_name': shopName,
      'amount': amount,
      'collected_at': collectedAt.toUtc().toIso8601String(),
      'method': method.name,
      'mode': mode.name,
      'status': status.name,
      'notes': notes,
      'reference': reference,
      'proof_photo_base64': proofPhotoBase64,
      'handover_id': handoverId,
      'lines': lines.map((line) => line.toJson()).toList(),
    };
  }

  RmCollectionSummaryModel copyWith({
    CollectionStatus? status,
    String? handoverId,
    String? proofPhotoBase64,
    List<RmCollectionLineModel>? lines,
  }) {
    return RmCollectionSummaryModel(
      id: id,
      receiptNumber: receiptNumber,
      shopId: shopId,
      shopName: shopName,
      amount: amount,
      collectedAt: collectedAt,
      method: method,
      mode: mode,
      status: status ?? this.status,
      notes: notes,
      reference: reference,
      proofPhotoBase64: proofPhotoBase64 ?? this.proofPhotoBase64,
      handoverId: handoverId ?? this.handoverId,
      lines: lines ?? this.lines,
    );
  }
}
