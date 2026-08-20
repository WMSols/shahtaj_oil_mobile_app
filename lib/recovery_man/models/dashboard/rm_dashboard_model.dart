import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/dashboard/rm_targets_model.dart';

class RmDashboardModel {
  const RmDashboardModel({
    this.collectedToday = 0,
    this.stillDue = 0,
    this.cashInBag = 0,
    this.shopsDueCount = 0,
    this.recentCollections = const [],
    this.targets = const RmTargetsModel(),
  });

  final double collectedToday;
  final double stillDue;
  final double cashInBag;
  final int shopsDueCount;
  final List<RmCollectionSummaryModel> recentCollections;
  final RmTargetsModel targets;

  factory RmDashboardModel.fromJson(Map<String, dynamic> json) {
    return RmDashboardModel(
      collectedToday: ApiMap.asDouble(json['collected_today']) ?? 0,
      stillDue: ApiMap.asDouble(json['still_due']) ?? 0,
      cashInBag: ApiMap.asDouble(json['cash_in_bag']) ?? 0,
      shopsDueCount: ApiMap.asInt(json['shops_due_count']) ?? 0,
      recentCollections: ApiMap.listOf(
        json,
        'recent_collections',
      ).map(RmCollectionSummaryModel.fromJson).toList(growable: false),
      targets: RmTargetsModel.fromJson(
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
