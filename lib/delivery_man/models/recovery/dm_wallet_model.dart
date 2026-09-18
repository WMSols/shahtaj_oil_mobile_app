import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmWalletModel {
  const DmWalletModel({
    this.deliveryManId,
    this.currency = 'PKR',
    this.balance = 0,
    this.collectedToday = 0,
    this.collectedTotal = 0,
    this.settledTotal = 0,
    this.asOf,
  });

  final int? deliveryManId;
  final String currency;
  final double balance;
  final double collectedToday;
  final double collectedTotal;
  final double settledTotal;
  final DateTime? asOf;

  factory DmWalletModel.fromJson(Map<String, dynamic> json) {
    return DmWalletModel(
      deliveryManId: ApiMap.asInt(json['delivery_man_id']),
      currency: ApiMap.asString(json['currency']) ?? 'PKR',
      balance: ApiMap.asDouble(json['balance']) ?? 0,
      collectedToday: ApiMap.asDouble(json['collected_today']) ?? 0,
      collectedTotal: ApiMap.asDouble(json['collected_total']) ?? 0,
      settledTotal: ApiMap.asDouble(json['settled_total']) ?? 0,
      asOf: ApiMap.asDateTime(json['as_of']),
    );
  }

  Map<String, dynamic> toJson() => {
    'delivery_man_id': deliveryManId,
    'currency': currency,
    'balance': balance,
    'collected_today': collectedToday,
    'collected_total': collectedTotal,
    'settled_total': settledTotal,
    'as_of': asOf?.toIso8601String(),
  };
}
