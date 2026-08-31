import 'package:flutter/scheduler.dart';

import 'package:shahtaj_oil_mobile_app/common/bindings/account/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/shell/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/shell/ob_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/dashboard/ob_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/history/ob_history_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/shops/ob_my_shops_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/tasks/ob_route_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/shops/ob_shop_onboarding_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/targets/ob_targets_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/schedule/ob_weekly_schedule_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/dashboard/ob_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/tasks/ob_route_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/schedule/ob_weekly_schedule_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/dashboard/ob_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/history/ob_history_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/shops/ob_my_shops_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/tasks/ob_route_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/shops/ob_shop_onboarding_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/targets/ob_targets_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/schedule/ob_weekly_schedule_screen.dart';
import 'package:get/get.dart';

class OrderBookerShellController extends AppShellController {
  /// Pops pushed OB routes back to the shell without recreating it.
  ///
  /// [Get.offAllNamed] on the same shell route destroys and rebuilds the
  /// navigator root, which can leave a black screen on release builds.
  static void returnToTodayTasks() {
    while (Get.currentRoute != AppRoutes.orderBooker &&
        (Get.key.currentState?.canPop() ?? false)) {
      Get.back();
    }

    if (Get.currentRoute != AppRoutes.orderBooker) {
      Get.offAllNamed(AppRoutes.orderBooker);
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<OrderBookerShellController>()) {
        Get.find<OrderBookerShellController>().selectLeaf('ob_today_tasks');
      }
    });
  }

  @override
  void onInit() {
    OrderBookerServicesBinding.ensureRegistered();
    super.onInit();
  }

  @override
  void selectLeaf(String id) {
    super.selectLeaf(id);
    _refreshLeafData(id);
  }

  void _refreshLeafData(String id) {
    switch (id) {
      case 'ob_today_tasks':
        if (Get.isRegistered<ObRouteDetailController>()) {
          Get.find<ObRouteDetailController>().loadTasks(
            silent: true,
            force: true,
          );
        }
        break;
      case 'ob_dashboard':
        if (Get.isRegistered<ObDashboardController>()) {
          Get.find<ObDashboardController>().loadDashboard(force: true);
        }
        break;
      case 'ob_weekly_schedule':
        if (Get.isRegistered<ObWeeklyScheduleController>()) {
          Get.find<ObWeeklyScheduleController>().load(force: true);
        }
        break;
    }
  }

  @override
  List<AppDrawerEntry> get drawerEntries => [
    AppDrawerEntry.leaf((
      id: 'ob_dashboard',
      icon: AppIcons.dashboard,
      label: AppTexts.navDashboard,
      screen: const ObDashboardScreen(),
      initBinding: () => ObDashboardBinding().dependencies(),
    )),
    AppDrawerEntry.group(
      AppDrawerGroup(
        id: 'ob_field_work',
        icon: AppIcons.fieldWork,
        label: AppTexts.obFieldWorkTitle,
        children: [
          (
            id: 'ob_weekly_schedule',
            icon: AppIcons.calendar,
            label: AppTexts.navWeeklySchedule,
            screen: const ObWeeklyScheduleScreen(embeddedInShell: true),
            initBinding: () => ObWeeklyScheduleBinding().dependencies(),
          ),
          (
            id: 'ob_today_tasks',
            icon: AppIcons.task,
            label: AppTexts.navTodayTasks,
            screen: const ObRouteDetailScreen(embeddedInShell: true),
            initBinding: () => ObRouteDetailBinding().dependencies(),
          ),
        ],
      ),
    ),
    AppDrawerEntry.group(
      AppDrawerGroup(
        id: 'ob_shops',
        icon: AppIcons.shops,
        label: AppTexts.navShops,
        children: [
          (
            id: 'ob_shop_register',
            icon: AppIcons.addshop,
            label: AppTexts.obShopOnboardingTitle,
            screen: const ObShopOnboardingScreen(embeddedInShell: true),
            initBinding: () => ObShopOnboardingBinding().dependencies(),
          ),
          (
            id: 'ob_my_shops',
            icon: AppIcons.myshops,
            label: AppTexts.obMyShopsTitle,
            screen: const ObMyShopsScreen(embeddedInShell: true),
            initBinding: () => ObMyShopsBinding().dependencies(),
          ),
        ],
      ),
    ),
    AppDrawerEntry.group(
      AppDrawerGroup(
        id: 'ob_performance',
        icon: AppIcons.invoices,
        label: AppTexts.navOrders,
        children: [
          (
            id: 'ob_targets',
            icon: AppIcons.dashboard,
            label: AppTexts.obTargets,
            screen: const ObTargetsScreen(embeddedInShell: true),
            initBinding: () => ObTargetsBinding().dependencies(),
          ),
          (
            id: 'ob_history',
            icon: AppIcons.history,
            label: AppTexts.navHistory,
            screen: const ObHistoryScreen(embeddedInShell: true),
            initBinding: () => ObHistoryBinding().dependencies(),
          ),
        ],
      ),
    ),
    AppDrawerEntry.leaf((
      id: 'ob_account',
      icon: AppIcons.account,
      label: AppTexts.navAccount,
      screen: const AccountScreen(),
      initBinding: () => AccountBinding().dependencies(),
    )),
  ];
}
