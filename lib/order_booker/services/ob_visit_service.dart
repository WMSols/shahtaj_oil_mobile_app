import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_summary_model.dart';

class ObVisitService extends GetxService {
  ObVisitService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  Future<ObVisitListResult> fetchMyVisits({
    int limit = 50,
    int offset = 0,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final cacheable =
        offset == 0 && dateFrom == null && dateTo == null && limit <= 50;

    final body = {
      'limit': limit,
      'offset': offset,
      if (dateFrom != null) 'date_from': AppFormatter.apiDate(dateFrom),
      if (dateTo != null) 'date_to': AppFormatter.apiDate(dateTo),
    };

    if (!cacheable) {
      final data = await _api.postData(ApiEndpoints.obVisitsMine, data: body);
      return ObVisitListResult.fromJson(data);
    }

    return _cache.readThrough(
      key: OfflineCacheKeys.visitsMine,
      fetch: () => _api.postData(ApiEndpoints.obVisitsMine, data: body),
      parse: ObVisitListResult.fromJson,
    );
  }

  Future<ObVisitDetailModel> fetchVisitDetail({required int visitId}) async {
    final data = await _api.postData(
      ApiEndpoints.obVisitsGet,
      data: {'visit_id': visitId},
    );
    final visitJson = ApiMap.asMap(data['visit']) ?? data;
    return ObVisitDetailModel.fromJson(visitJson);
  }
}
