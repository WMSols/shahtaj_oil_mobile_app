import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_today_tasks_model.dart';

class ObTaskService extends GetxService {
  ObTaskService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  List<ObTaskModel> _tasks = const [];
  ObRouteModel? _route;
  ObActiveVisitModel? _activeVisit;

  Future<ObTodayTasksModel> fetchTodayTasks() {
    return _cache.readThrough(
      key: OfflineCacheKeys.tasksToday,
      fetch: () => _api.postData(ApiEndpoints.obTasksToday),
      parse: (data) => _applyToday(ObTodayTasksModel.fromJson(data)),
    );
  }

  ObTodayTasksModel _applyToday(ObTodayTasksModel today) {
    _route = today.route;
    _tasks = List<ObTaskModel>.from(today.tasks);
    return today;
  }

  Future<ObActiveVisitModel?> fetchActiveVisit() async {
    try {
      final data = await _api.postData(ApiEndpoints.obVisitsActive);
      await _cache.saveMap(OfflineCacheKeys.activeVisit, data);
      return _applyActiveVisit(data);
    } catch (_) {
      final cached = await _cache.readMap(OfflineCacheKeys.activeVisit);
      if (cached != null) return _applyActiveVisit(cached);
      // Don't fail tasks/screens solely because visit probe failed.
      return _activeVisit;
    }
  }

  ObActiveVisitModel? _applyActiveVisit(Map<String, dynamic> data) {
    final visitJson = ApiMap.asMap(data['visit']);
    if (visitJson == null) {
      _activeVisit = null;
      return null;
    }
    final visit = ObActiveVisitModel.fromJson(visitJson);
    _activeVisit = visit.visitId == 0 ? null : visit;
    return _activeVisit;
  }

  Future<ObTaskModel?> findTaskById(int taskId) async {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (_) {
      await fetchTodayTasks();
      try {
        return _tasks.firstWhere((task) => task.id == taskId);
      } catch (_) {
        return null;
      }
    }
  }

  Future<ObTaskModel?> findTaskByShopId(String shopId) async {
    try {
      return _tasks.firstWhere((task) => task.shopId == shopId);
    } catch (_) {
      await fetchTodayTasks();
      try {
        return _tasks.firstWhere((task) => task.shopId == shopId);
      } catch (_) {
        return null;
      }
    }
  }

  ObActiveVisitModel? get activeVisitSync => _activeVisit;

  Future<ObActiveVisitModel> checkIn({
    required int taskId,
    required double latitude,
    required double longitude,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.obTasksCheckIn,
      data: {'task_id': taskId, 'latitude': latitude, 'longitude': longitude},
    );
    final visitJson = ApiMap.asMap(data['visit']) ?? data;
    final visit = ObActiveVisitModel.fromJson(visitJson);
    _activeVisit = visit;
    await _cache.saveMap(OfflineCacheKeys.activeVisit, {
      'visit': visit.toJson(),
    });
    await fetchTodayTasks();
    return visit;
  }

  Future<void> completeActiveVisit({required int visitId}) async {
    final current = _activeVisit;
    if (current == null || current.visitId != visitId) {
      _activeVisit = null;
      return;
    }
    _activeVisit = null;
    await _cache.saveMap(OfflineCacheKeys.activeVisit, const {});
    await fetchTodayTasks();
  }

  Future<void> clearActiveVisit({required int visitId}) async {
    final current = _activeVisit;
    if (current != null && current.visitId != visitId) return;
    _activeVisit = null;
    await _cache.saveMap(OfflineCacheKeys.activeVisit, const {});
    await fetchTodayTasks();
  }

  Future<void> skipTask(int taskId) async {
    await _api.postData(ApiEndpoints.obTasksSkip, data: {'task_id': taskId});
    if (_activeVisit?.taskId == taskId) {
      _activeVisit = null;
      await _cache.saveMap(OfflineCacheKeys.activeVisit, const {});
    }
    await fetchTodayTasks();
  }

  Future<void> saveTaskNotes({
    required int taskId,
    required String notes,
  }) async {
    await _api.postData(
      ApiEndpoints.obTasksNotes,
      data: {'task_id': taskId, 'notes': notes.trim()},
    );
    await fetchTodayTasks();
  }

  Future<void> startRoute(String routeId) async {
    final currentRoute = _route;
    if (currentRoute == null || currentRoute.id != routeId) return;
    _route = ObRouteModel(
      id: currentRoute.id,
      name: currentRoute.name,
      description: currentRoute.description,
      shopCount: currentRoute.shopCount,
      distanceKm: currentRoute.distanceKm,
      status: currentRoute.status,
    );
  }
}
