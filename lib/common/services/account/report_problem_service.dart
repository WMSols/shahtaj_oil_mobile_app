import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/account/report_problem_kind.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';

class ReportProblemService extends GetxService {
  ReportProblemService({
    OfflineCacheService? cache,
    ConnectivityService? connectivity,
    SessionService? session,
  }) : _cache = cache ?? Get.find<OfflineCacheService>(),
       _connectivity = connectivity ?? Get.find<ConnectivityService>(),
       _session = session ?? Get.find<SessionService>();

  final OfflineCacheService _cache;
  final ConnectivityService _connectivity;
  final SessionService _session;

  static const _action = 'report_problem';

  @override
  void onInit() {
    super.onInit();
    _cache.registerSyncHandler('orderBooker', _action, (_) async {});
    _cache.registerSyncHandler('deliveryMan', _action, (_) async {});
  }

  Future<void> submit({
    required ReportProblemKind? kind,
    required String details,
  }) async {
    final role = _session.role.value ?? UserRole.orderBooker;
    await _cache.enqueueSync(
      role: role.name,
      action: _action,
      payload: {
        'kind': kind?.name,
        'details': details.trim(),
        'reported_at': DateTime.now().toIso8601String(),
      },
    );
    if (_connectivity.isOnline.value) {
      await _cache.flushSyncQueue();
    }
  }
}
