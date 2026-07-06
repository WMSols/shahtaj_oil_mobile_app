import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
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
    final routeJson = json['route'] as Map<String, dynamic>? ?? {};
    final tasksJson = json['tasks'] as List<dynamic>? ?? const [];

    return ObTodayTasksModel(
      route: ObRouteModel.fromJson(routeJson),
      tasks: tasksJson
          .map((item) => ObTaskModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  ObTodayTasksModel copyWith({ObRouteModel? route, List<ObTaskModel>? tasks}) =>
      ObTodayTasksModel(route: route ?? this.route, tasks: tasks ?? this.tasks);
}
