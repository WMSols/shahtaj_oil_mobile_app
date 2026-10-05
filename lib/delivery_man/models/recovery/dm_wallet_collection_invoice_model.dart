import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

/// Per-invoice breakdown on a wallet collection (`invoice_details`).
class DmWalletCollectionInvoiceModel {
  const DmWalletCollectionInvoiceModel({
    required this.invoiceId,
    required this.name,
    this.amountTotal = 0,
    this.amountPaid = 0,
    this.amountResidual = 0,
    this.paymentState,
  });

  final int invoiceId;
  final String name;
  final double amountTotal;
  final double amountPaid;
  final double amountResidual;
  final String? paymentState;

  DmInvoicePaymentState? get resolvedPaymentState {
    final parsed = DmInvoicePaymentStateX.tryParse(paymentState);
    if (parsed != null) return parsed;
    if (amountResidual <= 0 && amountTotal > 0) {
      return DmInvoicePaymentState.paid;
    }
    if (amountPaid > 0 && amountResidual > 0) {
      return DmInvoicePaymentState.partial;
    }
    if (amountTotal > 0 && amountPaid <= 0) {
      return DmInvoicePaymentState.notPaid;
    }
    return null;
  }

  factory DmWalletCollectionInvoiceModel.fromJson(Map<String, dynamic> json) {
    final total = ApiMap.asDouble(json['amount_total']) ?? 0;
    final residual = ApiMap.asDouble(json['amount_residual']) ?? 0;
    final paid =
        ApiMap.asDouble(json['amount_paid']) ??
        ((total > residual && residual >= 0) ? (total - residual) : 0);
    return DmWalletCollectionInvoiceModel(
      invoiceId: ApiMap.asInt(json['invoice_id'] ?? json['id']) ?? 0,
      name: ApiMap.asString(json['name']) ?? '',
      amountTotal: total,
      amountPaid: paid,
      amountResidual: residual,
      paymentState: ApiMap.asString(json['payment_state']),
    );
  }

  Map<String, dynamic> toJson() => {
    'invoice_id': invoiceId,
    'name': name,
    'amount_total': amountTotal,
    'amount_paid': amountPaid,
    'amount_residual': amountResidual,
    'payment_state': paymentState,
  };
}
