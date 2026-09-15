import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/session/dm_session_model.dart';

/// Owns today's DM day session (`office` → `on_the_way` → `ended`).
class DmSessionService extends GetxService {
  DmSessionService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  final Rxn<DmSessionModel> session = Rxn<DmSessionModel>();

  DmSessionModel? get current => session.value;

  bool get isOffice => current?.isOffice ?? false;
  bool get isOnTheWay => current?.isOnTheWay ?? false;
  bool get isEnded => current?.isEnded ?? false;

  /// Seeds session from login / auth/me payload without a network round-trip.
  Future<void> applyFromPayload(Map<String, dynamic>? json) async {
    final sessionJson = ApiMap.asMap(json);
    if (sessionJson == null) return;
    await _setSession(DmSessionModel.fromJson(sessionJson));
  }

  Future<DmSessionModel?> loadCached() async {
    final cached = await _cache.readMap(OfflineCacheKeys.dmSession);
    if (cached == null) return session.value;
    final next = DmSessionModel.fromJson(cached);
    session.value = next;
    return next;
  }

  Future<DmSessionModel> fetchSession({bool forceNetwork = false}) async {
    if (!forceNetwork) {
      final cached = await loadCached();
      if (cached != null && _cache.shouldServeCacheFirst()) {
        return cached;
      }
    }

    final data = await _api.postData(ApiEndpoints.dmSessionGet);
    return _setSession(_parseSession(data));
  }

  Future<DmSessionModel> depart({String? notes}) async {
    final data = await _api.postData(
      ApiEndpoints.dmSessionDepart,
      data: {
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );
    return _setSession(_parseSession(data));
  }

  Future<DmSessionModel> end({String? notes}) async {
    final data = await _api.postData(
      ApiEndpoints.dmSessionEnd,
      data: {
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );
    return _setSession(_parseSession(data));
  }

  void clear() {
    session.value = null;
  }

  DmSessionModel _parseSession(Map<String, dynamic> data) {
    final sessionJson = ApiMap.asMap(data['session']) ?? data;
    return DmSessionModel.fromJson(sessionJson);
  }

  Future<DmSessionModel> _setSession(DmSessionModel next) async {
    session.value = next;
    await _cache.saveMap(OfflineCacheKeys.dmSession, next.toJson());
    return next;
  }
}
