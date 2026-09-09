import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_approval_info.dart';

class ObOrderSummaryModel {
  const ObOrderSummaryModel({
    required this.id,
    required this.orderNumber,
    required this.shopName,
    required this.amount,
    this.approval = ObOrderApprovalInfo.empty,
  });

  final String id;
  final String orderNumber;
  final String shopName;
  final double amount;
  final ObOrderApprovalInfo approval;

  factory ObOrderSummaryModel.fromJson(Map<String, dynamic> json) {
    final approval = ObOrderApprovalInfo.fromOrderAndVisit(
      order: json,
      visit: json,
    );
    return ObOrderSummaryModel(
      id: json['id']?.toString() ?? '',
      orderNumber:
          json['order_number']?.toString() ?? json['name']?.toString() ?? '',
      shopName: json['shop_name']?.toString() ?? '',
      amount:
          (json['amount'] as num?)?.toDouble() ??
          (json['amount_total'] as num?)?.toDouble() ??
          approval.amountTotal ??
          0,
      approval: approval,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'shop_name': shopName,
      'amount': amount,
      'approval_state': approval.state.name,
      if (approval.label != null) 'approval_state_label': approval.label,
      'approval_reasons': approval.reasons.map((r) => r.name).toList(),
      'requires_discount_approval': approval.requiresDiscountApproval,
      'requires_credit_approval': approval.requiresCreditApproval,
      if (approval.rejectionReason != null)
        'rejection_reason': approval.rejectionReason,
      if (approval.verifiedAt != null)
        'verified_at': approval.verifiedAt!.toIso8601String(),
      'has_discount': approval.hasDiscount,
      if (approval.discountAmount != null)
        'discount_amount': approval.discountAmount,
      if (approval.amountTotal != null) 'amount_total': approval.amountTotal,
    };
  }
}
