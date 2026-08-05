import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/shell/order_booker_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/dashboard/ob_dashboard_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/schedule/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_targets_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/dashboard/ob_dashboard_service.dart';

class ObDashboardController extends GetxController with CachedLoadMixin {
  ObDashboardController(this._service, this._session);

  final ObDashboardService _service;
  final SessionService _session;

  final Rxn<ObDashboardModel> dashboard = Rxn<ObDashboardModel>();

  @override
  bool get hasCachedData => dashboard.value != null;

  @override
  String get loadFailedMessage => 'Failed to load dashboard';

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  String get greeting => AppFormatter.timeOfDayGreeting();
  String get userName => _session.user.value?.name ?? 'Ahmed';
  ObRouteModel? get todaysRoute => dashboard.value?.todaysRoute;
  int get completedTasks => dashboard.value?.completedTasks ?? 0;
  int get totalTasks => dashboard.value?.totalTasks ?? 0;
  List<ObOrderSummaryModel> get recentOrders =>
      dashboard.value?.recentOrders ?? const [];
  ObTargetsModel get targets =>
      dashboard.value?.targets ?? const ObTargetsModel();

  /// Prefer network; only used by [loadCached]. Force refresh rejects stale disk.
  bool _allowStaleFallback = true;

  Future<void> loadDashboard({bool force = false}) async {
    _allowStaleFallback = !force;
    await loadCached(force: force);
  }

  @override
  Future<void> fetchData() async {
    dashboard.value = await _service.fetchDashboard(
      allowStaleFallback: _allowStaleFallback,
    );
  }

  Future<void> onRouteAction() async {
    final route = todaysRoute;
    if (route == null) return;

    if (route.status == RouteStatus.notStarted) {
      await _service.startRoute(route.id);
    } else if (route.status == RouteStatus.inProgress) {
      await _service.continueRoute(route.id);
    }
    Get.toNamed(_routeWithId(AppRoutes.obRouteDetail, route.id));
  }

  void goToRouteDetail() {
    if (Get.isRegistered<OrderBookerShellController>()) {
      Get.find<OrderBookerShellController>().selectLeaf('ob_today_tasks');
      return;
    }
    final route = todaysRoute;
    if (route == null || route.id.isEmpty) return;
    Get.toNamed(_routeWithId(AppRoutes.obRouteDetail, route.id));
  }

  void goToTargets() {
    if (Get.isRegistered<OrderBookerShellController>()) {
      Get.find<OrderBookerShellController>().selectLeaf('ob_targets');
    }
  }

  void goToOrderHistory() {
    if (Get.isRegistered<OrderBookerShellController>()) {
      Get.find<OrderBookerShellController>().selectLeaf('ob_history');
    }
  }

  void openOrder(ObOrderSummaryModel order) => Get.toNamed(
    _routeWithId(AppRoutes.obOrderDetail, order.id),
    arguments: {'visitId': order.id},
  );

  String _routeWithId(String routePattern, String id) =>
      routePattern.replaceFirst(':id', id);
}
