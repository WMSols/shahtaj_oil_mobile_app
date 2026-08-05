import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/schedule/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_targets_model.dart';

class ObDashboardModel {
  const ObDashboardModel({
    this.todaysRoute,
    this.recentOrders = const [],
    this.targets = const ObTargetsModel(),
    this.completedTasks = 0,
    this.totalTasks = 0,
  });

  final ObRouteModel? todaysRoute;
  final List<ObOrderSummaryModel> recentOrders;
  final ObTargetsModel targets;
  final int completedTasks;
  final int totalTasks;

  factory ObDashboardModel.fromJson(Map<String, dynamic> json) {
    final routeJson = json['todays_route'] ?? json['route'];
    return ObDashboardModel(
      todaysRoute: routeJson is Map<String, dynamic>
          ? ObRouteModel.fromJson(routeJson)
          : null,
      recentOrders: (json['recent_orders'] as List<dynamic>? ?? [])
          .map((e) => ObOrderSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      targets: ObTargetsModel.fromJson(
        json['targets'] as Map<String, dynamic>? ?? const {},
      ),
      completedTasks: ApiMap.asInt(json['completed_tasks']) ?? 0,
      totalTasks: ApiMap.asInt(json['total_tasks']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (todaysRoute != null) 'todays_route': todaysRoute!.toJson(),
      'recent_orders': recentOrders.map((e) => e.toJson()).toList(),
      'targets': targets.toJson(),
      'completed_tasks': completedTasks,
      'total_tasks': totalTasks,
    };
  }
}
