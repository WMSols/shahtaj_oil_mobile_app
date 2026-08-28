import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

enum ReportProblemKind {
  roadClosed,
  wrongRoute,
  shopClosed,
  shopLocationWrong,
  appNotWorking,
  noOrder,
  shopSaidNo,
  shopInfoWrong,
  productProblem,
  stockShort,
  stockDamaged,
  wrongStock,
  vehicleProblem,
  shopRefusedDelivery,
  collectionProblem,
  handoverProblem,
  other,
}

enum ReportProblemAudience { both, orderBooker, deliveryMan }

extension ReportProblemKindX on ReportProblemKind {
  ReportProblemAudience get audience => switch (this) {
    ReportProblemKind.roadClosed ||
    ReportProblemKind.wrongRoute ||
    ReportProblemKind.shopClosed ||
    ReportProblemKind.shopLocationWrong ||
    ReportProblemKind.appNotWorking ||
    ReportProblemKind.other => ReportProblemAudience.both,
    ReportProblemKind.noOrder ||
    ReportProblemKind.shopSaidNo ||
    ReportProblemKind.shopInfoWrong ||
    ReportProblemKind.productProblem => ReportProblemAudience.orderBooker,
    ReportProblemKind.stockShort ||
    ReportProblemKind.stockDamaged ||
    ReportProblemKind.wrongStock ||
    ReportProblemKind.vehicleProblem ||
    ReportProblemKind.shopRefusedDelivery ||
    ReportProblemKind.collectionProblem ||
    ReportProblemKind.handoverProblem => ReportProblemAudience.deliveryMan,
  };

  String get label => switch (this) {
    ReportProblemKind.roadClosed => AppTexts.reportProblemChipRoadClosed,
    ReportProblemKind.wrongRoute => AppTexts.reportProblemChipWrongRoute,
    ReportProblemKind.shopClosed => AppTexts.reportProblemChipShopClosed,
    ReportProblemKind.shopLocationWrong =>
      AppTexts.reportProblemChipShopLocationWrong,
    ReportProblemKind.appNotWorking => AppTexts.reportProblemChipAppNotWorking,
    ReportProblemKind.noOrder => AppTexts.reportProblemChipNoOrder,
    ReportProblemKind.shopSaidNo => AppTexts.reportProblemChipShopSaidNo,
    ReportProblemKind.shopInfoWrong => AppTexts.reportProblemChipShopInfoWrong,
    ReportProblemKind.productProblem =>
      AppTexts.reportProblemChipProductProblem,
    ReportProblemKind.stockShort => AppTexts.reportProblemChipStockShort,
    ReportProblemKind.stockDamaged => AppTexts.reportProblemChipStockDamaged,
    ReportProblemKind.wrongStock => AppTexts.reportProblemChipWrongStock,
    ReportProblemKind.vehicleProblem =>
      AppTexts.reportProblemChipVehicleProblem,
    ReportProblemKind.shopRefusedDelivery =>
      AppTexts.reportProblemChipShopRefusedDelivery,
    ReportProblemKind.collectionProblem =>
      AppTexts.reportProblemChipCollectionProblem,
    ReportProblemKind.handoverProblem =>
      AppTexts.reportProblemChipHandoverProblem,
    ReportProblemKind.other => AppTexts.reportProblemChipOther,
  };

  bool visibleFor(UserRole role) => switch (audience) {
    ReportProblemAudience.both => true,
    ReportProblemAudience.orderBooker => role == UserRole.orderBooker,
    ReportProblemAudience.deliveryMan => role == UserRole.deliveryMan,
  };

  static List<ReportProblemKind> chipsFor(UserRole role) => ReportProblemKind
      .values
      .where((kind) => kind.visibleFor(role))
      .toList(growable: false);
}
