import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_invoice_model.dart';

class DmRecoveryShopModel {
  const DmRecoveryShopModel({
    required this.shopId,
    required this.shopName,
    this.shopCategory,
    this.outstanding = 0,
    this.postedReceivable = 0,
    this.effectiveOutstanding = 0,
    this.creditLimit = 0,
    this.creditRemaining = 0,
    this.invoiceCount = 0,
    this.invoices = const [],
    this.paidInvoiceCount = 0,
    this.paidInvoices = const [],
    this.walletBalance = 0,
  });

  final String shopId;
  final String shopName;
  final String? shopCategory;
  final double outstanding;
  final double postedReceivable;
  final double effectiveOutstanding;
  final double creditLimit;
  final double creditRemaining;
  final int invoiceCount;
  final List<DmRecoveryInvoiceModel> invoices;
  final int paidInvoiceCount;
  final List<DmRecoveryInvoiceModel> paidInvoices;
  final double walletBalance;

  bool get isCreditLimitExceeded =>
      creditLimit > 0 && effectiveOutstanding > creditLimit;

  List<DmRecoveryInvoiceModel> get openInvoices =>
      invoices.where((i) => i.isOpen).toList(growable: false);

  factory DmRecoveryShopModel.fromJson(Map<String, dynamic> json) {
    final paid = ApiMap.listOf(
      json,
      'paid_invoices',
    ).map(DmRecoveryInvoiceModel.fromJson).toList(growable: false);
    return DmRecoveryShopModel(
      shopId: (ApiMap.asInt(json['shop_id']) ?? json['shop_id'] ?? '')
          .toString(),
      shopName: ApiMap.asString(json['shop_name']) ?? '',
      shopCategory: ApiMap.asString(json['shop_category']),
      outstanding: ApiMap.asDouble(json['outstanding']) ?? 0,
      postedReceivable: ApiMap.asDouble(json['posted_receivable']) ?? 0,
      effectiveOutstanding: ApiMap.asDouble(json['effective_outstanding']) ?? 0,
      creditLimit: ApiMap.asDouble(json['credit_limit']) ?? 0,
      creditRemaining: ApiMap.asDouble(json['credit_remaining']) ?? 0,
      invoiceCount: ApiMap.asInt(json['invoice_count']) ?? 0,
      invoices: ApiMap.listOf(
        json,
        'invoices',
      ).map(DmRecoveryInvoiceModel.fromJson).toList(growable: false),
      paidInvoiceCount: ApiMap.asInt(json['paid_invoice_count']) ?? paid.length,
      paidInvoices: paid,
      walletBalance: ApiMap.asDouble(json['wallet_balance']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'shop_id': shopId,
    'shop_name': shopName,
    'shop_category': shopCategory,
    'outstanding': outstanding,
    'posted_receivable': postedReceivable,
    'effective_outstanding': effectiveOutstanding,
    'credit_limit': creditLimit,
    'credit_remaining': creditRemaining,
    'invoice_count': invoiceCount,
    'invoices': invoices.map((e) => e.toJson()).toList(growable: false),
    'paid_invoice_count': paidInvoiceCount,
    'paid_invoices': paidInvoices
        .map((e) => e.toJson())
        .toList(growable: false),
    'wallet_balance': walletBalance,
  };
}
