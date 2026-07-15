import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_target_item_model.dart';

class ObTargetsService extends GetxService {
  ObTargetsService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  Future<List<ObTargetItemModel>> fetchTargets() {
    return _cache.readThrough(
      key: OfflineCacheKeys.targetsMine,
      fetch: () => _api.postData(ApiEndpoints.obTargetsMine),
      parse: _parseTargets,
    );
  }

  List<ObTargetItemModel> _parseTargets(Map<String, dynamic> data) {
    return ApiMap.listOf(
      data,
      'targets',
    ).map(ObTargetItemModel.fromJson).toList(growable: false);
  }
}
