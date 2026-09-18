import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmRecoveryPaymentModel {
  const DmRecoveryPaymentModel({
    required this.paymentId,
    required this.paymentName,
    this.paymentDate,
    this.amount = 0,
    this.paymentMethod = PaymentMethod.cash,
    this.chequeNumber,
    this.collectedByDmId,
    this.collectedByDmName,
    this.isDmWalletCollection = false,
  });

  final int paymentId;
  final String paymentName;
  final DateTime? paymentDate;
  final double amount;
  final PaymentMethod paymentMethod;
  final String? chequeNumber;
  final int? collectedByDmId;
  final String? collectedByDmName;
  final bool isDmWalletCollection;

  factory DmRecoveryPaymentModel.fromJson(Map<String, dynamic> json) {
    final cheque = ApiMap.asString(json['cheque_number']);
    return DmRecoveryPaymentModel(
      paymentId: ApiMap.asInt(json['payment_id'] ?? json['id']) ?? 0,
      paymentName: ApiMap.asString(json['payment_name'] ?? json['name']) ?? '',
      paymentDate: ApiMap.asDateTime(json['payment_date'] ?? json['date']),
      amount: ApiMap.asDouble(json['amount']) ?? 0,
      paymentMethod: PaymentMethodX.fromApi(json['payment_method']),
      chequeNumber: (cheque == null || cheque.trim().isEmpty) ? null : cheque,
      collectedByDmId: ApiMap.asInt(json['collected_by_dm_id']),
      collectedByDmName: ApiMap.asString(json['collected_by_dm_name']),
      isDmWalletCollection: json['is_dm_wallet_collection'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'payment_id': paymentId,
    'payment_name': paymentName,
    'payment_date': paymentDate?.toIso8601String(),
    'amount': amount,
    'payment_method': paymentMethod.name,
    'cheque_number': chequeNumber,
    'collected_by_dm_id': collectedByDmId,
    'collected_by_dm_name': collectedByDmName,
    'is_dm_wallet_collection': isDmWalletCollection,
  };
}
