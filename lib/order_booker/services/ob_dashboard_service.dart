import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_dashboard_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_target_item_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_targets_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_today_tasks_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_summary_model.dart';

class ObDashboardService extends GetxService {
  ObDashboardService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  Future<ObDashboardModel> fetchDashboard() {
    return _cache.readThrough(
      key: OfflineCacheKeys.dashboard,
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

        return ObDashboardModel(
          todaysRoute: today.route.id.isEmpty ? null : today.route,
          recentOrders: visits.visits
              .where((visit) => visit.outcome == VisitOutcome.orderPlaced)
              .map(_orderFromVisit)
              .toList(growable: false),
          targets: _targetsSummary(targets),
        ).toJson();
      },
      parse: ObDashboardModel.fromJson,
    );
  }

  ObTargetsModel _targetsSummary(List<ObTargetItemModel> items) {
    if (items.isEmpty) return const ObTargetsModel();
    var current = 0.0;
    var target = 0.0;
    for (final item in items) {
      current += item.current;
      target += item.target;
    }
    return ObTargetsModel(
      ordersCurrent: current.round(),
      ordersTarget: target.round(),
    );
  }

  ObOrderSummaryModel _orderFromVisit(ObVisitSummaryModel visit) {
    final number = visit.orderNumber ?? 'SO-${visit.visitId}';
    return ObOrderSummaryModel(
      // Route param for order detail is visit_id (via visits/get).
      id: '${visit.visitId}',
      orderNumber: number,
      shopName: visit.shopName,
      amount: visit.subtotal ?? 0,
      // Dashboard recent orders are always visit outcomes with an order.
      status: OrderStatus.submitted,
    );
  }

  Future<void> startRoute(String routeId) async {
    // No dedicated start-route API in Shahtaj v1.
  }

  Future<void> continueRoute(String routeId) async {
    // No dedicated continue-route API in Shahtaj v1.
  }
}
