import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_task_model.dart';

class ObTodayTasksModel {
  const ObTodayTasksModel({required this.route, required this.tasks});

  final ObRouteModel route;
  final List<ObTaskModel> tasks;

  int get completedCount =>
      tasks.where((task) => task.status == TaskStatus.completed).length;

  int get totalCount => tasks.length;

  double get progress =>
      totalCount == 0 ? 0 : completedCount / totalCount.toDouble();

  ObTaskModel? get nextPendingTask {
    for (final task in tasks) {
      if (task.status == TaskStatus.pending) return task;
    }
    return null;
  }

  factory ObTodayTasksModel.fromJson(Map<String, dynamic> json) {
    final tasksJson = ApiMap.listOf(json, 'tasks');
    final tasks = <ObTaskModel>[];
    for (var i = 0; i < tasksJson.length; i++) {
      final task = ObTaskModel.fromJson(tasksJson[i]);
      tasks.add(task.sequence == 0 ? task.copyWith(sequence: i + 1) : task);
    }

    final routeJson =
        ApiMap.asMap(json['route']) ??
        (tasksJson.isNotEmpty
            ? ApiMap.asMap(tasksJson.first['route'])
            : null) ??
        const <String, dynamic>{};

    return ObTodayTasksModel(route: _routeFrom(routeJson, tasks), tasks: tasks);
  }

  static ObRouteModel _routeFrom(
    Map<String, dynamic> routeJson,
    List<ObTaskModel> tasks,
  ) {
    final hasInVisit = tasks.any((task) => task.status == TaskStatus.inVisit);
    final hasProgress = tasks.any(
      (task) =>
          task.status == TaskStatus.completed ||
          task.status == TaskStatus.skipped ||
          task.status == TaskStatus.inVisit,
    );
    final allDone =
        tasks.isNotEmpty &&
        tasks.every(
          (task) =>
              task.status == TaskStatus.completed ||
              task.status == TaskStatus.skipped,
        );

    final status = allDone
        ? RouteStatus.completed
        : (hasInVisit || hasProgress)
        ? RouteStatus.inProgress
        : RouteStatus.notStarted;

    return ObRouteModel(
      id: ApiMap.asString(routeJson['id']) ?? '',
      name: ApiMap.asString(routeJson['name']) ?? '',
      description: ApiMap.asString(routeJson['description']),
      shopCount: ApiMap.asInt(routeJson['shop_count']) ?? tasks.length,
      distanceKm: ApiMap.asDouble(routeJson['distance_km']) ?? 0,
      status: routeJson['status'] != null
          ? ObRouteModel.parseStatus(routeJson['status'])
          : status,
    );
  }

  ObTodayTasksModel copyWith({ObRouteModel? route, List<ObTaskModel>? tasks}) =>
      ObTodayTasksModel(route: route ?? this.route, tasks: tasks ?? this.tasks);
}
