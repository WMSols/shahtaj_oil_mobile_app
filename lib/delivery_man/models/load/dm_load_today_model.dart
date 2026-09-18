import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/load/dm_pick_line_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/session/dm_session_model.dart';

class DmLoadTodayModel {
  const DmLoadTodayModel({
    this.date,
    this.session,
    this.shops = const [],
    this.pickLines = const [],
    this.vanQtyTotal = 0,
    this.warehouseQtyTotal = 0,
  });

  final DateTime? date;
  final DmSessionModel? session;
  final List<DmJobModel> shops;
  final List<DmPickLineModel> pickLines;
  final double vanQtyTotal;
  final double warehouseQtyTotal;

  factory DmLoadTodayModel.fromJson(Map<String, dynamic> json) {
    final sessionJson = ApiMap.asMap(json['session']);
    return DmLoadTodayModel(
      date: ApiMap.asDateTime(json['date']),
      session: sessionJson == null
          ? null
          : DmSessionModel.fromJson(sessionJson),
      shops: ApiMap.listOf(
        json,
        'shops',
      ).map(DmJobModel.fromJson).toList(growable: false),
      pickLines: ApiMap.listOf(
        json,
        'pick_lines',
      ).map(DmPickLineModel.fromJson).toList(growable: false),
      vanQtyTotal: ApiMap.asDouble(json['van_qty_total']) ?? 0,
      warehouseQtyTotal: ApiMap.asDouble(json['warehouse_qty_total']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date?.toIso8601String(),
    'session': session?.toJson(),
    'shops': shops.map((e) => e.toJson()).toList(growable: false),
    'pick_lines': pickLines.map((e) => e.toJson()).toList(growable: false),
    'van_qty_total': vanQtyTotal,
    'warehouse_qty_total': warehouseQtyTotal,
  };
}
