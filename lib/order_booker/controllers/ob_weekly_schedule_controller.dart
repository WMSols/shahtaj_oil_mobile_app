import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_dashboard_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_weekly_schedule_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_dashboard_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_weekly_schedule_service.dart';

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

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    final results = await Future.wait([
      _weeklyScheduleService.fetchWeeklySchedule(),
      _dashboardService.fetchDashboard(),
    ]);
    final schedule = results[0] as ObWeeklyScheduleModel;
    final dashboard = results[1] as ObDashboardModel;
    days.assignAll(schedule.days);
    todaysRoute.value = dashboard.todaysRoute;
  }

  Future<void> onTodayRouteAction() async {
    final route = todaysRoute.value;
    if (route == null) return;

    if (route.status == RouteStatus.notStarted) {
      await _dashboardService.startRoute(route.id);
    } else if (route.status == RouteStatus.inProgress) {
      await _dashboardService.continueRoute(route.id);
    }
    Get.toNamed(AppRoutes.obRouteDetail.replaceFirst(':id', route.id));
  }
}
