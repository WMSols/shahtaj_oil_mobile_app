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
import 'package:shahtaj_oil_mobile_app/delivery_man/services/walk_in_deliver/dm_walk_in_registry.dart';

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
    if (Get.isRegistered<DmWalkInRegistry>()) {
      await Get.find<DmWalkInRegistry>().hydrate();
    }
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

  Future<DmJobModel> fetchJob(int jobId, {bool forceNetwork = false}) async {
    if (!forceNetwork && _cache.shouldServeCacheFirst()) {
      final cached = await _jobFromCache(jobId);
      if (cached != null) {
        activeJob.value = cached;
        return cached;
      }
    }

    try {
      final data = await _api.postData(
        ApiEndpoints.dmPlanJob,
        data: {'job_id': jobId},
      );
      final job = _tagWalkIn(
        _withPreservedNotes(
          DmJobModel.fromJson(ApiMap.asMap(data['job']) ?? data),
        ),
      );
      activeJob.value = job;
      await _upsertJobInPlan(job);
      return job;
    } catch (_) {
      final cached = await _jobFromCache(jobId);
      if (cached != null) {
        activeJob.value = cached;
        return cached;
      }
      rethrow;
    }
  }

  Future<DmJobModel?> _jobFromCache(int jobId) async {
    final memory = plan.value?.jobs;
    if (memory != null) {
      for (final job in memory) {
        if (job.jobId == jobId) return job;
      }
    }
    final active = activeJob.value;
    if (active != null && active.jobId == jobId) return active;

    final cached = await _cache.readMap(OfflineCacheKeys.dmPlanToday);
    if (cached == null) return null;
    final parsed = DmPlanTodayModel.fromJson(
      ApiMap.asMap(cached['plan']) ?? cached,
    );
    plan.value ??= parsed;
    for (final job in parsed.jobs) {
      if (job.jobId == jobId) return job;
    }
    return null;
  }

  Future<DmJobModel> saveNotes({
    required int jobId,
    required String notes,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmJobNotes,
      data: {'job_id': jobId, 'notes': notes.trim()},
    );
    final job = _withPreservedNotes(
      DmJobModel.fromJson(ApiMap.asMap(data['job']) ?? data),
      fallbackNotes: notes.trim(),
    );
    activeJob.value = job;
    await _upsertJobInPlan(job);
    // Do not force-refresh plan here — list APIs often omit notes and would wipe them.
    return job;
  }

  Future<DmJobModel> markShopClosed({
    required int jobId,
    required String notes,
    required String shopClosedImageBase64,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmJobShopClosed,
      data: {
        'job_id': jobId,
        'notes': notes.trim(),
        'shop_closed_image': shopClosedImageBase64,
      },
    );
    return _applyJobResponse(data, fallbackNotes: notes);
  }

  Future<DmJobModel> markFailed({required int jobId, String? notes}) async {
    final data = await _api.postData(
      ApiEndpoints.dmJobFailed,
      data: {
        'job_id': jobId,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );
    return _applyJobResponse(data, fallbackNotes: notes);
  }

  Future<DmJobModel> deliver({
    required int jobId,
    required double latitude,
    required double longitude,
    required List<({int lineId, double qty})> lines,
    required String receiverName,
    required String deliveryProofImageBase64,
    String? notes,
  }) async {
    final trimmedNotes = notes?.trim();
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
        if (trimmedNotes != null && trimmedNotes.isNotEmpty)
          'notes': trimmedNotes,
      },
    );
    return _applyJobResponse(data, fallbackNotes: trimmedNotes);
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

  DmJobModel _applyJobResponse(
    Map<String, dynamic> data, {
    String? fallbackNotes,
  }) {
    final job = _withPreservedNotes(
      DmJobModel.fromJson(ApiMap.asMap(data['job']) ?? data),
      fallbackNotes: fallbackNotes,
    );
    activeJob.value = job;
    unawaited(() async {
      await _upsertJobInPlan(job);
      await fetchToday(forceNetwork: true);
    }());
    return job;
  }

  DmJobModel _withPreservedNotes(DmJobModel incoming, {String? fallbackNotes}) {
    if ((incoming.notes ?? '').trim().isNotEmpty) return incoming;
    final fromFallback = fallbackNotes?.trim();
    if (fromFallback != null && fromFallback.isNotEmpty) {
      return incoming.copyWith(notes: fromFallback);
    }
    final prior = activeJob.value?.jobId == incoming.jobId
        ? activeJob.value
        : null;
    final fromActive = prior?.notes?.trim();
    if (fromActive != null && fromActive.isNotEmpty) {
      return incoming.copyWith(notes: fromActive);
    }
    final fromPlan = plan.value?.jobs
        .where((j) => j.jobId == incoming.jobId)
        .map((j) => j.notes?.trim())
        .whereType<String>()
        .where((n) => n.isNotEmpty)
        .firstOrNull;
    if (fromPlan != null) return incoming.copyWith(notes: fromPlan);
    return incoming;
  }

  Future<void> _upsertJobInPlan(DmJobModel job) async {
    final current = plan.value;
    if (current == null) {
      await _cache.saveMap(OfflineCacheKeys.dmPlanToday, {
        'plan': DmPlanTodayModel(jobs: [job]).toJson(),
      });
      plan.value = DmPlanTodayModel(jobs: [job]);
      return;
    }
    final jobs = [...current.jobs];
    final index = jobs.indexWhere((j) => j.jobId == job.jobId);
    if (index >= 0) {
      jobs[index] = job;
    } else {
      jobs.add(job);
    }
    final next = DmPlanTodayModel(
      date: current.date,
      session: current.session,
      jobs: jobs,
      gpsCriteria: current.gpsCriteria,
    );
    plan.value = next;
    await _cache.saveMap(OfflineCacheKeys.dmPlanToday, {'plan': next.toJson()});
  }

  DmPlanTodayModel _applyPlan(DmPlanTodayModel next) {
    final previous = plan.value;
    final mergedJobs = [
      for (final job in next.jobs)
        _tagWalkIn(
          previous == null ? job : _mergeNotesFromPrior(job, previous.jobs),
        ),
    ];
    final merged = DmPlanTodayModel(
      date: next.date,
      session: next.session,
      gpsCriteria: next.gpsCriteria,
      jobs: mergedJobs,
    );
    plan.value = merged;
    final gps = merged.gpsCriteria;
    if (gps != null && Get.isRegistered<SessionService>()) {
      unawaited(Get.find<SessionService>().setGpsCriteria(gps));
    }
    final session = merged.session;
    if (session != null && Get.isRegistered<DmSessionService>()) {
      unawaited(
        Get.find<DmSessionService>().applyFromPayload(session.toJson()),
      );
    }
    return merged;
  }

  DmJobModel _mergeNotesFromPrior(DmJobModel job, List<DmJobModel> priorJobs) {
    if ((job.notes ?? '').trim().isNotEmpty) return job;
    for (final prior in priorJobs) {
      if (prior.jobId != job.jobId) continue;
      final notes = prior.notes?.trim();
      if (notes != null && notes.isNotEmpty) {
        return job.copyWith(notes: notes);
      }
    }
    return job;
  }

  DmJobModel _tagWalkIn(DmJobModel job) {
    if (job.isWalkIn) return job;
    if (!Get.isRegistered<DmWalkInRegistry>()) return job;
    final registry = Get.find<DmWalkInRegistry>();
    if (registry.isWalkInJob(job.jobId) || registry.isWalkInShop(job.shopId)) {
      return job.copyWith(isWalkIn: true);
    }
    return job;
  }
}
