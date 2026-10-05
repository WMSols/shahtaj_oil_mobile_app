import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_approval_info.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/sync/ob_day_bootstrap_service.dart';

class ObVisitSummaryModel {
  const ObVisitSummaryModel({
    required this.visitId,
    required this.shopName,
    required this.checkedInAt,
    required this.outcome,
    this.shopId,
    this.taskId,
    this.ownerName,
    this.checkedOutAt,
    this.orderId,
    this.orderNumber,
    this.subtotal,
    this.approval = ObOrderApprovalInfo.empty,
  });

  final int visitId;
  final String? shopId;
  final int? taskId;
  final String shopName;
  final String? ownerName;
  final DateTime checkedInAt;
  final DateTime? checkedOutAt;
  final VisitOutcome outcome;
  final int? orderId;
  final String? orderNumber;
  final double? subtotal;
  final ObOrderApprovalInfo approval;

  /// Stable key for one sale order. Null when the visit has no real order
  /// (no-order visits and pending-sync placeholders stay unique).
  String? get orderDedupeKey {
    if (orderId != null && orderId! > 0) return 'id:$orderId';
    final number = orderNumber?.trim();
    if (number == null || number.isEmpty) return null;
    if (number == ObDocKeys.pendingSyncOrderMarker) return null;
    return 'no:${number.toLowerCase()}';
  }

  /// Keeps one card per sale order when several visits share the same order.
  static List<ObVisitSummaryModel> dedupeByOrder(
    List<ObVisitSummaryModel> visits,
  ) {
    final seen = <String, int>{};
    final result = <ObVisitSummaryModel>[];

    for (final visit in visits) {
      final key = visit.orderDedupeKey;
      if (key == null) {
        result.add(visit);
        continue;
      }
      final existingIndex = seen[key];
      if (existingIndex == null) {
        seen[key] = result.length;
        result.add(visit);
        continue;
      }
      if (_isPreferredOver(visit, result[existingIndex])) {
        result[existingIndex] = visit;
      }
    }
    return result;
  }

  /// Prefer the real placement visit over a thin duplicate (e.g. instant close).
  static bool _isPreferredOver(
    ObVisitSummaryModel candidate,
    ObVisitSummaryModel existing,
  ) {
    final candidateDuration = _durationSeconds(candidate);
    final existingDuration = _durationSeconds(existing);
    if (candidateDuration != existingDuration) {
      return candidateDuration > existingDuration;
    }
    final byTime = candidate.checkedInAt.compareTo(existing.checkedInAt);
    if (byTime != 0) return byTime < 0;
    return candidate.visitId < existing.visitId;
  }

  static int _durationSeconds(ObVisitSummaryModel visit) {
    final out = visit.checkedOutAt;
    if (out == null) return 0;
    final seconds = out.difference(visit.checkedInAt).inSeconds;
    return seconds < 0 ? 0 : seconds;
  }

  factory ObVisitSummaryModel.fromJson(Map<String, dynamic> json) {
    final shop = ApiMap.asMap(json['shop']) ?? const <String, dynamic>{};
    final order = ApiMap.asMap(json['order']);
    final approval = ObOrderApprovalInfo.fromOrderAndVisit(
      order: order,
      visit: json,
    );
    final orderNumber =
        ApiMap.asString(json['order_number']) ??
        ApiMap.asString(json['sale_order_name']) ??
        ApiMap.asString(order?['name']);
    return ObVisitSummaryModel(
      visitId: ApiMap.asInt(json['visit_id']) ?? ApiMap.asInt(json['id']) ?? 0,
      shopId:
          ApiMap.asString(json['shop_id']) ??
          ApiMap.asString(shop['shop_id']) ??
          ApiMap.asString(shop['id']),
      taskId: ApiMap.asInt(json['task_id']),
      shopName:
          ApiMap.asString(json['shop_name']) ??
          ApiMap.asString(shop['name']) ??
          '',
      ownerName:
          ApiMap.asString(json['owner_name']) ??
          ApiMap.asString(shop['owner_name']),
      checkedInAt:
          ApiMap.asDateTime(json['checked_in_at']) ??
          ApiMap.asDateTime(json['started_at']) ??
          DateTime.now(),
      checkedOutAt:
          ApiMap.asDateTime(json['checked_out_at']) ??
          ApiMap.asDateTime(json['ended_at']),
      outcome: parseOutcome(ApiMap.asString(json['outcome'])),
      orderId: ApiMap.asInt(json['order_id']) ?? ApiMap.asInt(order?['id']),
      orderNumber: orderNumber,
      subtotal:
          ApiMap.asDouble(json['subtotal']) ??
          ApiMap.asDouble(json['order_amount']) ??
          approval.amountTotal,
      approval: approval,
    );
  }

  static VisitOutcome parseOutcome(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return VisitOutcome.endedWithoutOrder;
    }
    final value = raw.trim().toLowerCase();
    if (value == 'order' || value == 'order_placed' || value == 'orderplaced') {
      return VisitOutcome.orderPlaced;
    }
    if (value == 'no_order' ||
        value == 'no-order' ||
        value == 'ended_without_order' ||
        value == 'endedwithoutorder' ||
        value == 'no_sale' ||
        value == 'skipped' ||
        value == 'skip') {
      return VisitOutcome.endedWithoutOrder;
    }
    return VisitOutcome.values.firstWhere(
      (outcome) =>
          outcome.name == raw ||
          outcome.name == ApiMap.snakeToCamel(raw) ||
          outcome.name == raw.replaceAll('-', '_'),
      orElse: () => VisitOutcome.endedWithoutOrder,
    );
  }
}

class ObVisitListResult {
  const ObVisitListResult({required this.visits, required this.total});

  final List<ObVisitSummaryModel> visits;
  final int total;

  factory ObVisitListResult.fromJson(Map<String, dynamic> json) {
    final list = ApiMap.listOf(json, 'visits');
    return ObVisitListResult(
      visits: list.map(ObVisitSummaryModel.fromJson).toList(growable: false),
      total: ApiMap.asInt(json['total']) ?? list.length,
    );
  }
}
