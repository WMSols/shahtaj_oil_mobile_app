import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_today_tasks_model.dart';

class ObTaskService extends GetxService {
  ObTaskService(this._api);

  final ApiClient _api;

  List<ObTaskModel> _tasks = List<ObTaskModel>.from(AppMockData.obTodayTasks);
  ObRouteModel _route = AppMockData.obTodaysRoute;
  ObActiveVisitModel? _activeVisit = AppMockData.obActiveVisit;

  Future<ObTodayTasksModel> fetchTodayTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return ObTodayTasksModel(
      route: _route,
      tasks: List<ObTaskModel>.from(_tasks),
    );
    // Swap with API when ready:
    // final response = await _api.get(ApiEndpoints.obTasksToday);
    // return ObTodayTasksModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ObActiveVisitModel?> fetchActiveVisit() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _activeVisit;
    // Swap with API when ready:
    // final response = await _api.get(ApiEndpoints.obVisitsActive);
    // final data = response.data as Map<String, dynamic>?;
    // if (data == null || data.isEmpty) return null;
    // return ObActiveVisitModel.fromJson(data);
  }

  Future<ObTaskModel?> findTaskById(int taskId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (_) {
      return null;
    }
  }

  Future<ObTaskModel?> findTaskByShopId(String shopId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    try {
      return _tasks.firstWhere((task) => task.shopId == shopId);
    } catch (_) {
      return null;
    }
  }

  Future<ObActiveVisitModel> checkIn({
    required int taskId,
    required double latitude,
    required double longitude,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    // Swap with API when ready:
    // final response = await _api.post(
    //   ApiEndpoints.obTasksCheckIn,
    //   data: {
    //     'task_id': taskId,
    //     'latitude': latitude,
    //     'longitude': longitude,
    //   },
    // );
    // final visit = ObActiveVisitModel.fromJson(
    //   response.data as Map<String, dynamic>,
    // );
    // _activeVisit = visit;
    // return visit;

    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) throw Exception('Task not found');

    final task = _tasks[index];
    _tasks = _tasks.map((item) {
      if (item.id == taskId) {
        return item.copyWith(status: TaskStatus.inVisit);
      }
      if (item.status == TaskStatus.inVisit) {
        return item.copyWith(status: TaskStatus.completed);
      }
      return item;
    }).toList();

    _route = ObRouteModel(
      id: _route.id,
      name: _route.name,
      description: _route.description,
      shopCount: _route.shopCount,
      distanceKm: _route.distanceKm,
      status: RouteStatus.inProgress,
    );

    final visit = ObActiveVisitModel(
      visitId: DateTime.now().millisecondsSinceEpoch,
      taskId: taskId,
      shopId: task.shopId,
      shopName: task.shopName,
      checkedInAt: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );
    _activeVisit = visit;
    return visit;
  }

  Future<void> skipTask(int taskId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // Swap with API when ready:
    // await _api.post(ApiEndpoints.obTasksSkip, data: {'task_id': taskId});

    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) throw Exception('Task not found');

    _tasks = _tasks
        .map(
          (task) => task.id == taskId
              ? task.copyWith(status: TaskStatus.skipped)
              : task,
        )
        .toList();

    if (_activeVisit?.taskId == taskId) {
      _activeVisit = null;
    }
  }

  Future<void> saveTaskNotes({
    required int taskId,
    required String notes,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    // Swap with API when ready:
    // await _api.post(
    //   ApiEndpoints.obTasksNotes,
    //   data: {'task_id': taskId, 'notes': notes},
    // );

    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) throw Exception('Task not found');

    _tasks = _tasks
        .map(
          (task) => task.id == taskId
              ? task.copyWith(notes: notes.trim().isEmpty ? null : notes.trim())
              : task,
        )
        .toList();
  }

  Future<void> startRoute(String routeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (_route.id != routeId) return;
    _route = ObRouteModel(
      id: _route.id,
      name: _route.name,
      description: _route.description,
      shopCount: _route.shopCount,
      distanceKm: _route.distanceKm,
      status: RouteStatus.inProgress,
    );
  }
}
