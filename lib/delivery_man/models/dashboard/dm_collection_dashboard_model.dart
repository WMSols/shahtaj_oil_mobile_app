import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_shop_due_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_targets_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/handover/dm_handover_summary_model.dart';

class DmCollectionDashboardModel {
  const DmCollectionDashboardModel({
    this.collectedToday = 0,
    this.stillDue = 0,
    this.cashInBag = 0,
    this.shopsDueCount = 0,
    this.bagReceiptCount = 0,
    this.highestDueShop,
    this.recentCollections = const [],
    this.recentHandovers = const [],
    this.targets = const DmTargetsModel(),
  });

  final double collectedToday;
  final double stillDue;
  final double cashInBag;
  final int shopsDueCount;
  final int bagReceiptCount;
  final DmShopDueModel? highestDueShop;
  final List<DmCollectionSummaryModel> recentCollections;
  final List<DmHandoverSummaryModel> recentHandovers;
  final DmTargetsModel targets;

  factory DmCollectionDashboardModel.fromJson(Map<String, dynamic> json) {
    final shopJson = ApiMap.asMap(json['highest_due_shop']);
    return DmCollectionDashboardModel(
      collectedToday: ApiMap.asDouble(json['collected_today']) ?? 0,
      stillDue: ApiMap.asDouble(json['still_due']) ?? 0,
      cashInBag: ApiMap.asDouble(json['cash_in_bag']) ?? 0,
      shopsDueCount: ApiMap.asInt(json['shops_due_count']) ?? 0,
      bagReceiptCount: ApiMap.asInt(json['bag_receipt_count']) ?? 0,
      highestDueShop: shopJson == null
          ? null
          : DmShopDueModel.fromJson(shopJson),
      recentCollections: ApiMap.listOf(
        json,
        'recent_collections',
      ).map(DmCollectionSummaryModel.fromJson).toList(growable: false),
      recentHandovers: ApiMap.listOf(
        json,
        'recent_handovers',
      ).map(DmHandoverSummaryModel.fromJson).toList(growable: false),
      targets: DmTargetsModel.fromJson(
        ApiMap.asMap(json['targets']) ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collected_today': collectedToday,
      'still_due': stillDue,
      'cash_in_bag': cashInBag,
      'shops_due_count': shopsDueCount,
      'bag_receipt_count': bagReceiptCount,
      'highest_due_shop': highestDueShop?.toJson(),
      'recent_collections': recentCollections.map((e) => e.toJson()).toList(),
      'recent_handovers': recentHandovers.map((e) => e.toJson()).toList(),
      'targets': targets.toJson(),
    };
  }
}
