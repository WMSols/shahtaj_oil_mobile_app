import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/session/dm_session_model.dart';

class DmPlanTodayModel {
  const DmPlanTodayModel({
    this.date,
    this.session,
    this.jobs = const [],
  });

  final DateTime? date;
  final DmSessionModel? session;
  final List<DmJobModel> jobs;

  factory DmPlanTodayModel.fromJson(Map<String, dynamic> json) {
    final sessionJson = ApiMap.asMap(json['session']);
    return DmPlanTodayModel(
      date: ApiMap.asDateTime(json['date']),
      session: sessionJson == null
          ? null
          : DmSessionModel.fromJson(sessionJson),
      jobs: ApiMap.listOf(json, 'jobs')
          .map(DmJobModel.fromJson)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date?.toIso8601String(),
    'session': session?.toJson(),
    'jobs': jobs.map((e) => e.toJson()).toList(growable: false),
  };
}
