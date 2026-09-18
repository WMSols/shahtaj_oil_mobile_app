import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_model.dart';

class DmRecoveryCollectResult {
  const DmRecoveryCollectResult({
    required this.shopId,
    required this.shopName,
    required this.collectedAmount,
    this.paymentMethod = PaymentMethod.cash,
    this.chequeNumber,
    this.hasChequeImage = false,
    this.paymentIds = const [],
    this.payments = const [],
    this.wallet,
    this.shop,
  });

  final String shopId;
  final String shopName;
  final double collectedAmount;
  final PaymentMethod paymentMethod;
  final String? chequeNumber;
  final bool hasChequeImage;
  final List<int> paymentIds;
  final List<DmRecoveryPaymentModel> payments;
  final DmWalletModel? wallet;
  final DmRecoveryShopModel? shop;

  factory DmRecoveryCollectResult.fromJson(Map<String, dynamic> json) {
    final paymentIdsRaw = json['payment_ids'];
    final paymentIds = <int>[];
    if (paymentIdsRaw is List) {
      for (final id in paymentIdsRaw) {
        final parsed = ApiMap.asInt(id);
        if (parsed != null) paymentIds.add(parsed);
      }
    }

    final walletJson = ApiMap.asMap(json['wallet']);
    final shopJson = ApiMap.asMap(json['shop']);

    return DmRecoveryCollectResult(
      shopId: (ApiMap.asInt(json['shop_id']) ?? json['shop_id'] ?? '')
          .toString(),
      shopName: ApiMap.asString(json['shop_name']) ?? '',
      collectedAmount: ApiMap.asDouble(json['collected_amount']) ?? 0,
      paymentMethod: PaymentMethodX.fromApi(json['payment_method']),
      chequeNumber: ApiMap.asString(json['cheque_number']),
      hasChequeImage: json['has_cheque_image'] == true,
      paymentIds: paymentIds,
      payments: ApiMap.listOf(
        json,
        'payments',
      ).map(DmRecoveryPaymentModel.fromJson).toList(growable: false),
      wallet: walletJson == null ? null : DmWalletModel.fromJson(walletJson),
      shop: shopJson == null ? null : DmRecoveryShopModel.fromJson(shopJson),
    );
  }
}

class DmRecoveryPaymentModel {
  const DmRecoveryPaymentModel({
    required this.paymentId,
    required this.name,
    required this.amount,
    this.date,
    this.paymentMethod = PaymentMethod.cash,
    this.chequeNumber,
    this.hasChequeImage = false,
  });

  final int paymentId;
  final String name;
  final double amount;
  final DateTime? date;
  final PaymentMethod paymentMethod;
  final String? chequeNumber;
  final bool hasChequeImage;

  factory DmRecoveryPaymentModel.fromJson(Map<String, dynamic> json) {
    return DmRecoveryPaymentModel(
      paymentId: ApiMap.asInt(json['payment_id'] ?? json['id']) ?? 0,
      name: ApiMap.asString(json['name']) ?? '',
      amount: ApiMap.asDouble(json['amount']) ?? 0,
      date: ApiMap.asDateTime(json['date']),
      paymentMethod: PaymentMethodX.fromApi(json['payment_method']),
      chequeNumber: ApiMap.asString(json['cheque_number']),
      hasChequeImage: json['has_cheque_image'] == true,
    );
  }
}
