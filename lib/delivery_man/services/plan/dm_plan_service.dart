import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/plan/dm_plan_today_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/session/dm_session_service.dart';

/// Live day plan + field job actions.
class DmPlanService extends GetxService {
  DmPlanService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  final Rxn<DmPlanTodayModel> plan = Rxn<DmPlanTodayModel>();
  final Rxn<DmJobModel> activeJob = Rxn<DmJobModel>();

  DmPlanTodayModel? get current => plan.value;

  Future<DmPlanTodayModel> fetchToday({bool forceNetwork = false}) async {
    final result = await _cache.readThrough(
      key: OfflineCacheKeys.dmPlanToday,
      fetch: () => _api.postData(ApiEndpoints.dmPlanToday),
      parse: (json) =>
          DmPlanTodayModel.fromJson(ApiMap.asMap(json['plan']) ?? json),
      allowStaleFallback: true,
      cacheFirst: _cache.cacheFirstFor(
        allowStaleFallback: true,
        forceNetwork: forceNetwork,
      ),
    );
    return _applyPlan(result);
  }

  Future<DmJobModel> fetchJob(int jobId, {bool forceNetwork = true}) async {
    final data = await _api.postData(
      ApiEndpoints.dmPlanJob,
      data: {'job_id': jobId},
    );
    final job = DmJobModel.fromJson(ApiMap.asMap(data['job']) ?? data);
    activeJob.value = job;
    _upsertJobInPlan(job);
    return job;
  }

  Future<DmJobModel> saveNotes({
    required int jobId,
    required String notes,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmJobNotes,
      data: {'job_id': jobId, 'notes': notes.trim()},
    );
    return _applyJobResponse(data);
  }

  Future<DmJobModel> markShopClosed({required int jobId, String? notes}) async {
    final data = await _api.postData(
      ApiEndpoints.dmJobShopClosed,
      data: {
        'job_id': jobId,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );
    return _applyJobResponse(data);
  }

  Future<DmJobModel> markFailed({required int jobId, String? notes}) async {
    final data = await _api.postData(
      ApiEndpoints.dmJobFailed,
      data: {
        'job_id': jobId,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );
    return _applyJobResponse(data);
  }

  Future<DmJobModel> deliver({
    required int jobId,
    required double latitude,
    required double longitude,
    required List<({int lineId, double qty})> lines,
    required String receiverName,
    required String deliveryProofImageBase64,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmJobDeliver,
      data: {
        'job_id': jobId,
        'latitude': latitude,
        'longitude': longitude,
        'receiver_name': receiverName.trim(),
        'delivery_proof_image': deliveryProofImageBase64,
        'lines': [
          for (final line in lines)
            if (line.qty > 0) {'line_id': line.lineId, 'qty': line.qty},
        ],
      },
    );
    return _applyJobResponse(data);
  }

  Future<DmJobModel> returnUndelivered({
    required int jobId,
    required List<({int lineId, double qty})> lines,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmJobReturnUndelivered,
      data: {
        'job_id': jobId,
        'lines': [
          for (final line in lines)
            if (line.qty > 0) {'line_id': line.lineId, 'qty': line.qty},
        ],
      },
    );
    return _applyJobResponse(data);
  }

  DmJobModel _applyJobResponse(Map<String, dynamic> data) {
    final job = DmJobModel.fromJson(ApiMap.asMap(data['job']) ?? data);
    activeJob.value = job;
    _upsertJobInPlan(job);
    unawaited(fetchToday(forceNetwork: true));
    return job;
  }

  void _upsertJobInPlan(DmJobModel job) {
    final current = plan.value;
    if (current == null) return;
    final jobs = [...current.jobs];
    final index = jobs.indexWhere((j) => j.jobId == job.jobId);
    if (index >= 0) {
      jobs[index] = job;
    } else {
      jobs.add(job);
    }
    plan.value = DmPlanTodayModel(
      date: current.date,
      session: current.session,
      jobs: jobs,
      gpsCriteria: current.gpsCriteria,
    );
  }

  DmPlanTodayModel _applyPlan(DmPlanTodayModel next) {
    plan.value = next;
    final gps = next.gpsCriteria;
    if (gps != null && Get.isRegistered<SessionService>()) {
      unawaited(Get.find<SessionService>().setGpsCriteria(gps));
    }
    final session = next.session;
    if (session != null && Get.isRegistered<DmSessionService>()) {
      unawaited(
        Get.find<DmSessionService>().applyFromPayload(session.toJson()),
      );
    }
    return next;
  }
}
