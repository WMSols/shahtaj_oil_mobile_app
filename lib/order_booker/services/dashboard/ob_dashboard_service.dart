import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/dashboard/ob_dashboard_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/history/ob_visit_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_target_item_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_targets_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_today_tasks_model.dart';

class ObDashboardService extends GetxService {
  ObDashboardService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  Future<ObDashboardModel> fetchDashboard({
    bool allowStaleFallback = true,
    bool forceNetwork = false,
  }) {
    return _cache.readThrough(
      key: OfflineCacheKeys.dashboard,
      allowStaleFallback: allowStaleFallback,
      cacheFirst: _cache.cacheFirstFor(
        allowStaleFallback: allowStaleFallback,
        forceNetwork: forceNetwork,
      ),
      fetch: () async {
        final results = await Future.wait([
          _api.postData(ApiEndpoints.obTasksToday),
          _api.postData(ApiEndpoints.obTargetsMine),
          _api.postData(
            ApiEndpoints.obVisitsMine,
            data: const {'limit': 5, 'offset': 0},
          ),
        ]);

        final today = ObTodayTasksModel.fromJson(results[0]);
        final targets = ApiMap.listOf(
          results[1],
          'targets',
        ).map(ObTargetItemModel.fromJson).toList(growable: false);
        final visits = ObVisitListResult.fromJson(results[2]);

        final orderVisits = visits.visits
            .where((visit) => visit.outcome == VisitOutcome.orderPlaced)
            .toList(growable: false);
        final todayStart = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );
        final ordersToday = orderVisits
            .where((visit) {
              final at = visit.checkedOutAt ?? visit.checkedInAt;
              return !at.isBefore(todayStart);
            })
            .toList(growable: false);

        final pendingApprovalCount = orderVisits
            .where(
              (visit) => visit.approval.state == ObOrderApprovalState.toApprove,
            )
            .length;

        return ObDashboardModel(
          todaysRoute: today.route.id.isEmpty ? null : today.route,
          completedTasks: today.completedCount,
          pendingTasks: today.pendingCount,
          inVisitTasks: today.inVisitCount,
          totalTasks: today.totalCount,
          ordersTodayCount: ordersToday.length,
          ordersTodayValue: ordersToday.fold<double>(
            0,
            (sum, visit) => sum + (visit.subtotal ?? 0),
          ),
          pendingApprovalCount: pendingApprovalCount,
          recentOrders: orderVisits
              .map(_orderFromVisit)
              .toList(growable: false),
          targets: _targetsSummary(targets),
        ).toJson();
      },
      parse: ObDashboardModel.fromJson,
    );
  }

  ObTargetsModel _targetsSummary(List<ObTargetItemModel> items) {
    return ObTargetsModel.fromTargets(items);
  }

  ObOrderSummaryModel _orderFromVisit(ObVisitSummaryModel visit) {
    final number = visit.orderNumber ?? 'SO-${visit.visitId}';
    return ObOrderSummaryModel(
      id: '${visit.visitId}',
      orderNumber: number,
      shopName: visit.shopName,
      amount: visit.subtotal ?? 0,
      approval: visit.approval,
    );
  }

  Future<void> startRoute(String routeId) async {}

  Future<void> continueRoute(String routeId) async {}
}
