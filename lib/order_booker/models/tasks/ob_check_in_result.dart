import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_missing_field.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_model.dart';

/// Result of `POST /tasks/check-in` or `POST /shops/verify-on-site`.
class ObCheckInResult {
  const ObCheckInResult({
    this.visit,
    this.shop,
    this.needsShopSetup = false,
    this.fieldVerified = true,
    this.visitTag = 'visited',
    this.missingFields = const [],
    this.message,
    this.resumed = false,
  });

  final ObActiveVisitModel? visit;
  final ObShopModel? shop;
  final bool needsShopSetup;
  final bool fieldVerified;
  final String visitTag;
  final List<ObShopMissingField> missingFields;
  final String? message;
  final bool resumed;

  bool get hasVisit => visit != null && visit!.visitId > 0;

  factory ObCheckInResult.fromJson(Map<String, dynamic> json) {
    final shopJson = ApiMap.asMap(json['shop']);
    final visitJson = ApiMap.asMap(json['visit']);
    final needsSetup = json['needs_shop_setup'] == true;

    ObActiveVisitModel? visit;
    if (visitJson != null) {
      final parsed = ObActiveVisitModel.fromJson(visitJson);
      visit = parsed.visitId > 0 ? parsed : null;
    }

    final missing = ObShopMissingField.listFrom(json['missing_fields']);

    return ObCheckInResult(
      visit: visit,
      shop: shopJson == null ? null : ObShopModel.fromJson(shopJson),
      needsShopSetup: needsSetup,
      fieldVerified: json['field_verified'] == true || !needsSetup,
      visitTag:
          ApiMap.asString(json['visit_tag']) ??
          (needsSetup ? 'not_visited' : 'visited'),
      missingFields: missing,
      message: ApiMap.asString(json['message']),
      resumed: json['resumed'] == true,
    );
  }
}
