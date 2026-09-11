import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

/// Approval payload from visit / visit.order responses (OB_API_Changes).
class ObOrderApprovalInfo {
  const ObOrderApprovalInfo({
    this.state = ObOrderApprovalState.none,
    this.reasons = const [],
    this.requiresDiscountApproval = false,
    this.requiresCreditApproval = false,
    this.label,
    this.rejectionReason,
    this.verifiedAt,
    this.hasDiscount = false,
    this.discountAmount,
    this.orderState,
    this.isPlaced = false,
    this.amountTotal,
  });

  final ObOrderApprovalState state;
  final List<ObOrderApprovalReason> reasons;
  final bool requiresDiscountApproval;
  final bool requiresCreditApproval;
  final String? label;
  final String? rejectionReason;
  final DateTime? verifiedAt;
  final bool hasDiscount;
  final double? discountAmount;
  final String? orderState;
  final bool isPlaced;
  final double? amountTotal;

  bool get needsVerification =>
      state == ObOrderApprovalState.toApprove ||
      requiresDiscountApproval ||
      requiresCreditApproval ||
      reasons.isNotEmpty;

  bool get isPendingVerification => state == ObOrderApprovalState.toApprove;

  bool get isRejected => state == ObOrderApprovalState.rejected;

  bool get isVerified => state == ObOrderApprovalState.approved;

  bool get isStandard =>
      state == ObOrderApprovalState.none && !needsVerification;

  bool get hasDiscountReason =>
      requiresDiscountApproval ||
      reasons.contains(ObOrderApprovalReason.discount);

  bool get hasCreditReason =>
      requiresCreditApproval || reasons.contains(ObOrderApprovalReason.credit);

  String get displayLabel {
    // Prefer localized labels so API "Pending verification" does not collide
    // with visit/task "Pending".
    return state.label;
  }

  static const empty = ObOrderApprovalInfo();

  factory ObOrderApprovalInfo.fromVisitJson(Map<String, dynamic> json) {
    final order = ApiMap.asMap(json['order']);
    return ObOrderApprovalInfo.fromOrderAndVisit(order: order, visit: json);
  }

  factory ObOrderApprovalInfo.fromOrderAndVisit({
    Map<String, dynamic>? order,
    Map<String, dynamic>? visit,
  }) {
    final o = order ?? const <String, dynamic>{};
    final v = visit ?? const <String, dynamic>{};

    final state =
        ObOrderApprovalStateX.tryParse(
          ApiMap.asString(o['approval_state']) ??
              ApiMap.asString(v['order_approval_state']) ??
              ApiMap.asString(v['approval_state']),
        ) ??
        ObOrderApprovalState.none;

    final reasons = ObOrderApprovalReasonX.parseList(
      o['approval_reasons'] ?? v['order_approval_reasons'],
    );

    final requiresDiscount =
        o['requires_discount_approval'] == true ||
        v['order_requires_discount_approval'] == true ||
        reasons.contains(ObOrderApprovalReason.discount);

    final requiresCredit =
        o['requires_credit_approval'] == true ||
        v['order_requires_credit_approval'] == true ||
        reasons.contains(ObOrderApprovalReason.credit);

    return ObOrderApprovalInfo(
      state: state,
      reasons: reasons,
      requiresDiscountApproval: requiresDiscount,
      requiresCreditApproval: requiresCredit,
      label:
          ApiMap.asString(o['approval_state_label']) ??
          ApiMap.asString(v['order_approval_state_label']),
      rejectionReason: ApiMap.asString(o['rejection_reason']),
      verifiedAt: ApiMap.asDateTime(o['verified_at']),
      hasDiscount: o['has_discount'] == true || requiresDiscount,
      discountAmount: ApiMap.asDouble(o['discount_amount']),
      orderState: ApiMap.asString(o['state']),
      isPlaced: o['is_placed'] == true,
      amountTotal:
          ApiMap.asDouble(o['amount_total']) ??
          ApiMap.asDouble(v['order_amount']) ??
          ApiMap.asDouble(v['subtotal']),
    );
  }
}
