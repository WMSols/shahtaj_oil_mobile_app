import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_collection_targets_model.dart';

class DmCollectionDashboardModel {
  const DmCollectionDashboardModel({
    this.collectedToday = 0,
    this.stillDue = 0,
    this.cashInBag = 0,
    this.shopsDueCount = 0,
    this.recentCollections = const [],
    this.targets = const DmCollectionTargetsModel(),
  });

  final double collectedToday;
  final double stillDue;
  final double cashInBag;
  final int shopsDueCount;
  final List<DmCollectionSummaryModel> recentCollections;
  final DmCollectionTargetsModel targets;

  factory DmCollectionDashboardModel.fromJson(Map<String, dynamic> json) {
    return DmCollectionDashboardModel(
      collectedToday: ApiMap.asDouble(json['collected_today']) ?? 0,
      stillDue: ApiMap.asDouble(json['still_due']) ?? 0,
      cashInBag: ApiMap.asDouble(json['cash_in_bag']) ?? 0,
      shopsDueCount: ApiMap.asInt(json['shops_due_count']) ?? 0,
      recentCollections: ApiMap.listOf(
        json,
        'recent_collections',
      ).map(DmCollectionSummaryModel.fromJson).toList(growable: false),
      targets: DmCollectionTargetsModel.fromJson(
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
      'recent_collections': recentCollections.map((e) => e.toJson()).toList(),
      'targets': targets.toJson(),
    };
  }
}
