import 'package:shahtaj_oil_mobile_app/core/models/gps_criteria.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/session/dm_session_model.dart';

class DmPlanTodayModel {
  const DmPlanTodayModel({
    this.date,
    this.session,
    this.jobs = const [],
    this.gpsCriteria,
  });

  final DateTime? date;
  final DmSessionModel? session;
  final List<DmJobModel> jobs;
  final GpsCriteria? gpsCriteria;

  factory DmPlanTodayModel.fromJson(Map<String, dynamic> json) {
    final sessionJson = ApiMap.asMap(json['session']);
    return DmPlanTodayModel(
      date: ApiMap.asDateTime(json['date']),
      session: sessionJson == null
          ? null
          : DmSessionModel.fromJson(sessionJson),
      jobs: ApiMap.listOf(
        json,
        'jobs',
      ).map(DmJobModel.fromJson).toList(growable: false),
      gpsCriteria: GpsCriteria.tryParse(json['gps_criteria']),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date?.toIso8601String(),
    'session': session?.toJson(),
    'jobs': jobs.map((e) => e.toJson()).toList(growable: false),
    if (gpsCriteria != null) 'gps_criteria': gpsCriteria!.toJson(),
  };
}
