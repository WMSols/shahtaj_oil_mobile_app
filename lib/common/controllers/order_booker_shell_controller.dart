import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_history_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_my_shops_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_active_visit_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_route_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_shop_onboarding_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_targets_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_weekly_schedule_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_active_visit_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_history_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_my_shops_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_route_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_shop_onboarding_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_targets_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_weekly_schedule_screen.dart';

class OrderBookerShellController extends AppShellController {
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
          (
            id: 'ob_active_visit',
            icon: AppIcons.data,
            label: AppTexts.obActiveVisitTitle,
            screen: const ObActiveVisitScreen(embeddedInShell: true),
            initBinding: () => ObActiveVisitBinding().dependencies(),
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
