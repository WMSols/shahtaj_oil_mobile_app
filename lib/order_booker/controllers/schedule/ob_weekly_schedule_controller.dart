import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/shell/ob_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/schedule/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/schedule/ob_weekly_schedule_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/dashboard/ob_dashboard_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/schedule/ob_weekly_schedule_service.dart';

class ObWeeklyScheduleController extends GetxController with CachedLoadMixin {
  ObWeeklyScheduleController(
    this._weeklyScheduleService,
    this._dashboardService,
  );

  final ObWeeklyScheduleService _weeklyScheduleService;
  final ObDashboardService _dashboardService;

  final RxList<ObWeeklyScheduleDayModel> days =
      <ObWeeklyScheduleDayModel>[].obs;
  final Rxn<ObRouteModel> todaysRoute = Rxn<ObRouteModel>();

  @override
  bool get hasCachedData => days.isNotEmpty;

  @override
  String get loadFailedMessage => AppTexts.error;

  int get todayWeekday => DateTime.now().weekday;

  bool isToday(ObWeeklyScheduleDayModel day) => day.weekday == todayWeekday;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    final force = isForceRefresh;

    // Load independently so a missing dashboard cache cannot blank the week.
    try {
      final schedule = await _weeklyScheduleService.fetchWeeklySchedule(
        forceNetwork: force,
      );
      days.assignAll(schedule.days);
    } catch (_) {
      if (days.isEmpty) rethrow;
    }

    try {
      final dashboard = await _dashboardService.fetchDashboard(
        forceNetwork: force,
      );
      todaysRoute.value = dashboard.todaysRoute;
    } catch (_) {
      // Schedule can still show without today's route action.
    }
  }

  Future<void> onTodayRouteAction() async {
    final route = todaysRoute.value;
    if (route == null) return;

    if (route.status == RouteStatus.notStarted) {
      await _dashboardService.startRoute(route.id);
    } else if (route.status == RouteStatus.inProgress) {
      await _dashboardService.continueRoute(route.id);
    }
    // Prefer shell leaf over stacking a second route-detail page.
    openTodayTasks();
  }

  void openTodayTasks() {
    if (Get.isRegistered<OrderBookerShellController>()) {
      Get.find<OrderBookerShellController>().selectLeaf('ob_today_tasks');
      return;
    }
    final route = todaysRoute.value;
    if (route == null || route.id.isEmpty) return;
    Get.toNamed(AppRoutes.obRouteDetail.replaceFirst(':id', route.id));
  }

  void onDayTap(ObWeeklyScheduleDayModel day) {
    if (!isToday(day) || day.isOffDay || !day.hasAssignment) return;
    openTodayTasks();
  }
}
