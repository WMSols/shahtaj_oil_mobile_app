import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmWalletCollectionModel {
  const DmWalletCollectionModel({
    required this.paymentId,
    required this.name,
    required this.date,
    required this.amount,
    required this.shopId,
    required this.shopName,
    this.invoices = const [],
    this.notes,
    this.paymentMethod = PaymentMethod.cash,
    this.chequeNumber,
    this.hasChequeImage = false,
  });

  final int paymentId;
  final String name;
  final DateTime date;
  final double amount;
  final String shopId;
  final String shopName;
  final List<String> invoices;
  final String? notes;
  final PaymentMethod paymentMethod;
  final String? chequeNumber;
  final bool hasChequeImage;

  factory DmWalletCollectionModel.fromJson(Map<String, dynamic> json) {
    final invoiceRaw = json['invoices'];
    final invoiceNames = <String>[];
    if (invoiceRaw is List) {
      for (final item in invoiceRaw) {
        if (item == null) continue;
        invoiceNames.add(item.toString());
      }
    }

    return DmWalletCollectionModel(
      paymentId: ApiMap.asInt(json['payment_id'] ?? json['id']) ?? 0,
      name: ApiMap.asString(json['name']) ?? '',
      date: ApiMap.asDateTime(json['date']) ?? DateTime.now(),
      amount: ApiMap.asDouble(json['amount']) ?? 0,
      shopId: (ApiMap.asInt(json['shop_id']) ?? json['shop_id'] ?? '')
          .toString(),
      shopName: ApiMap.asString(json['shop_name']) ?? '',
      invoices: invoiceNames,
      notes: ApiMap.asString(json['notes']),
      paymentMethod: PaymentMethodX.fromApi(json['payment_method']),
      chequeNumber: ApiMap.asString(json['cheque_number']),
      hasChequeImage: json['has_cheque_image'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'payment_id': paymentId,
    'name': name,
    'date': date.toIso8601String(),
    'amount': amount,
    'shop_id': shopId,
    'shop_name': shopName,
    'invoices': invoices,
    'notes': notes,
    'payment_method': paymentMethod.name,
    'cheque_number': chequeNumber,
    'has_cheque_image': hasChequeImage,
  };
}

class DmWalletCollectionsPage {
  const DmWalletCollectionsPage({
    this.count = 0,
    this.walletBalance = 0,
    this.collections = const [],
  });

  final int count;
  final double walletBalance;
  final List<DmWalletCollectionModel> collections;

  factory DmWalletCollectionsPage.fromJson(Map<String, dynamic> json) {
    return DmWalletCollectionsPage(
      count: ApiMap.asInt(json['count']) ?? 0,
      walletBalance: ApiMap.asDouble(json['wallet_balance']) ?? 0,
      collections: ApiMap.listOf(
        json,
        'collections',
      ).map(DmWalletCollectionModel.fromJson).toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'wallet_balance': walletBalance,
    'collections': collections.map((e) => e.toJson()).toList(growable: false),
  };
}
