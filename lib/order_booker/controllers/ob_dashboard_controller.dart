import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_dashboard_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_targets_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_dashboard_service.dart';

class ObDashboardController extends GetxController {
  ObDashboardController(this._service, this._session);

  final ObDashboardService _service;
  final SessionService _session;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final Rxn<ObDashboardModel> dashboard = Rxn<ObDashboardModel>();

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  String get greeting => AppFormatter.timeOfDayGreeting();
  String get userName => _session.user.value?.name ?? 'Ahmed';
  ObRouteModel? get todaysRoute => dashboard.value?.todaysRoute;
  List<ObOrderSummaryModel> get recentOrders =>
      dashboard.value?.recentOrders ?? const [];
  ObTargetsModel get targets =>
      dashboard.value?.targets ?? const ObTargetsModel();

  Future<void> loadDashboard() async {
    isLoading.value = true;
    error.value = null;
    try {
      dashboard.value = await _service.fetchDashboard();
    } catch (_) {
      error.value = 'Failed to load dashboard';
    } finally {
      isLoading.value = false;
    }
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

  void goToOrderHistory() => Get.toNamed(AppRoutes.obHistory);
  void openOrder(ObOrderSummaryModel order) =>
      Get.toNamed(_routeWithId(AppRoutes.obOrderDetail, order.id));

  String _routeWithId(String routePattern, String id) =>
      routePattern.replaceFirst(':id', id);
}
