import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_weekly_schedule_model.dart';

class ObWeeklyScheduleService extends GetxService {
  ObWeeklyScheduleService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  Future<ObWeeklyScheduleModel> fetchWeeklySchedule() {
    return _cache.readThrough(
      key: OfflineCacheKeys.scheduleWeekly,
      fetch: () => _api.postData(ApiEndpoints.obScheduleWeekly),
      parse: ObWeeklyScheduleModel.fromJson,
    );
  }
}
