import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/load/dm_load_today_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/session/dm_session_service.dart';

/// Office load: `load/today`, collective `load/pick`, per-job `job/pick`.
class DmLoadService extends GetxService {
  DmLoadService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  final Rxn<DmLoadTodayModel> load = Rxn<DmLoadTodayModel>();

  DmLoadTodayModel? get current => load.value;

  Future<DmLoadTodayModel> fetchToday({bool forceNetwork = false}) async {
    final result = await _cache.readThrough(
      key: OfflineCacheKeys.dmLoadToday,
      fetch: () => _api.postData(ApiEndpoints.dmLoadToday),
      parse: (json) =>
          DmLoadTodayModel.fromJson(ApiMap.asMap(json['load']) ?? json),
      allowStaleFallback: true,
      cacheFirst: _cache.cacheFirstFor(
        allowStaleFallback: true,
        forceNetwork: forceNetwork,
      ),
    );
    return _apply(result);
  }

  /// Collective pick: `[{ product_id, qty }]`.
  Future<DmLoadTodayModel> pickCollective({
    required List<({int productId, double qty})> lines,
  }) async {
    final payload = {
      'lines': [
        for (final line in lines)
          if (line.qty > 0) {'product_id': line.productId, 'qty': line.qty},
      ],
    };
    final data = await _api.postData(ApiEndpoints.dmLoadPick, data: payload);
    final loadJson = ApiMap.asMap(data['load']) ?? data;
    final next = DmLoadTodayModel.fromJson(loadJson);
    await _cache.saveMap(OfflineCacheKeys.dmLoadToday, next.toJson());
    return _apply(next);
  }

  /// Per-job pick: `[{ line_id, qty }]`.
  Future<DmJobModel> pickJob({
    required int jobId,
    required List<({int lineId, double qty})> lines,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmJobPick,
      data: {
        'job_id': jobId,
        'lines': [
          for (final line in lines)
            if (line.qty > 0) {'line_id': line.lineId, 'qty': line.qty},
        ],
      },
    );
    final jobJson = ApiMap.asMap(data['job']) ?? data;
    final job = DmJobModel.fromJson(jobJson);
    unawaited(fetchToday(forceNetwork: true));
    return job;
  }

  DmLoadTodayModel _apply(DmLoadTodayModel next) {
    load.value = next;
    final session = next.session;
    if (session != null && Get.isRegistered<DmSessionService>()) {
      unawaited(
        Get.find<DmSessionService>().applyFromPayload(session.toJson()),
      );
    }
    return next;
  }
}
