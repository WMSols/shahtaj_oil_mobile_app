import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_payment_model.dart';

class DmRecoveryInvoiceModel {
  const DmRecoveryInvoiceModel({
    required this.invoiceId,
    required this.name,
    this.invoiceDate,
    this.amountTotal = 0,
    this.amountResidual = 0,
    this.paymentState,
    this.isLegacyBalance = false,
    this.paidDate,
    this.payments = const [],
  });

  final int invoiceId;
  final String name;
  final DateTime? invoiceDate;
  final double amountTotal;
  final double amountResidual;
  final String? paymentState;
  final bool isLegacyBalance;
  final DateTime? paidDate;
  final List<DmRecoveryPaymentModel> payments;

  bool get isOpen => amountResidual > 0;

  bool get isPaid =>
      !isOpen ||
      (paymentState ?? '').toLowerCase() == 'paid' ||
      paidDate != null;

  factory DmRecoveryInvoiceModel.fromJson(Map<String, dynamic> json) {
    return DmRecoveryInvoiceModel(
      invoiceId: ApiMap.asInt(json['invoice_id'] ?? json['id']) ?? 0,
      name: ApiMap.asString(json['name']) ?? '',
      invoiceDate: ApiMap.asDateTime(json['invoice_date']),
      amountTotal: ApiMap.asDouble(json['amount_total']) ?? 0,
      amountResidual: ApiMap.asDouble(json['amount_residual']) ?? 0,
      paymentState: ApiMap.asString(json['payment_state']),
      isLegacyBalance: json['is_legacy_balance'] == true,
      paidDate: ApiMap.asDateTime(json['paid_date']),
      payments: ApiMap.listOf(
        json,
        'payments',
      ).map(DmRecoveryPaymentModel.fromJson).toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
    'invoice_id': invoiceId,
    'name': name,
    'invoice_date': invoiceDate?.toIso8601String(),
    'amount_total': amountTotal,
    'amount_residual': amountResidual,
    'payment_state': paymentState,
    'is_legacy_balance': isLegacyBalance,
    'paid_date': paidDate?.toIso8601String(),
    'payments': payments.map((e) => e.toJson()).toList(growable: false),
  };
}
