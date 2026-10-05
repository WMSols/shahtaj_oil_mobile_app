import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_collection_invoice_model.dart';

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
    this.isWalkIn = false,
    this.collectionStatus,
    this.invoiceAmountTotal = 0,
    this.invoiceAmountPaid = 0,
    this.invoiceAmountResidual = 0,
    this.invoiceDetails = const [],
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
  final bool isWalkIn;
  final DmWalletCollectionPayStatus? collectionStatus;
  final double invoiceAmountTotal;
  final double invoiceAmountPaid;
  final double invoiceAmountResidual;
  final List<DmWalletCollectionInvoiceModel> invoiceDetails;

  bool get hasInvoiceTotals =>
      invoiceAmountTotal > 0 ||
      invoiceAmountPaid > 0 ||
      invoiceAmountResidual > 0 ||
      invoiceDetails.isNotEmpty;

  factory DmWalletCollectionModel.fromJson(Map<String, dynamic> json) {
    final invoiceRaw = json['invoices'];
    final invoiceNames = <String>[];
    if (invoiceRaw is List) {
      for (final item in invoiceRaw) {
        if (item == null) continue;
        invoiceNames.add(item.toString());
      }
    }

    final details = ApiMap.listOf(
      json,
      'invoice_details',
    ).map(DmWalletCollectionInvoiceModel.fromJson).toList(growable: false);

    final total =
        ApiMap.asDouble(json['invoice_amount_total']) ??
        (details.isEmpty
            ? 0
            : details.fold<double>(0, (sum, d) => sum + d.amountTotal));
    final paid =
        ApiMap.asDouble(json['invoice_amount_paid']) ??
        (details.isEmpty
            ? 0
            : details.fold<double>(0, (sum, d) => sum + d.amountPaid));
    final residual =
        ApiMap.asDouble(json['invoice_amount_residual']) ??
        (details.isEmpty
            ? 0
            : details.fold<double>(0, (sum, d) => sum + d.amountResidual));

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
      hasChequeImage: ApiMap.asBool(json['has_cheque_image']),
      isWalkIn: _parseWalkIn(json),
      collectionStatus: DmWalletCollectionPayStatusX.tryParse(
        ApiMap.asString(json['collection_status']),
      ),
      invoiceAmountTotal: total,
      invoiceAmountPaid: paid,
      invoiceAmountResidual: residual,
      invoiceDetails: details,
    );
  }

  static bool _parseWalkIn(Map<String, dynamic> json) {
    const keys = [
      'is_walk_in',
      'walk_in',
      'is_walkin',
      'walkin',
      'is_walk_in_collection',
      'is_cash_and_carry',
    ];
    for (final key in keys) {
      if (json.containsKey(key) && ApiMap.asBool(json[key])) return true;
    }
    for (final key in [
      'source',
      'origin',
      'collection_type',
      'payment_source',
    ]) {
      final type = (ApiMap.asString(json[key]) ?? '')
          .trim()
          .toLowerCase()
          .replaceAll('-', '_')
          .replaceAll(' ', '_');
      if (type.contains('walk_in') ||
          type.contains('walkin') ||
          type == 'cash_and_carry') {
        return true;
      }
    }
    return false;
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
    'is_walk_in': isWalkIn,
    if (collectionStatus != null)
      'collection_status': switch (collectionStatus!) {
        DmWalletCollectionPayStatus.paid => 'paid',
        DmWalletCollectionPayStatus.partial => 'partial',
        DmWalletCollectionPayStatus.notPaid => 'not_paid',
        DmWalletCollectionPayStatus.collected => 'collected',
        DmWalletCollectionPayStatus.canceled => 'canceled',
      },
    'invoice_amount_total': invoiceAmountTotal,
    'invoice_amount_paid': invoiceAmountPaid,
    'invoice_amount_residual': invoiceAmountResidual,
    'invoice_details': invoiceDetails
        .map((e) => e.toJson())
        .toList(growable: false),
  };

  DmWalletCollectionModel copyWith({bool? isWalkIn}) {
    return DmWalletCollectionModel(
      paymentId: paymentId,
      name: name,
      date: date,
      amount: amount,
      shopId: shopId,
      shopName: shopName,
      invoices: invoices,
      notes: notes,
      paymentMethod: paymentMethod,
      chequeNumber: chequeNumber,
      hasChequeImage: hasChequeImage,
      isWalkIn: isWalkIn ?? this.isWalkIn,
      collectionStatus: collectionStatus,
      invoiceAmountTotal: invoiceAmountTotal,
      invoiceAmountPaid: invoiceAmountPaid,
      invoiceAmountResidual: invoiceAmountResidual,
      invoiceDetails: invoiceDetails,
    );
  }
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
