import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/bindings/account/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/shell/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/dashboard/rm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/collections/rm_today_shops_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/handover/rm_handover_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/history/rm_history_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/dashboard/rm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/handover/rm_handover_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/history/rm_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/collections/rm_today_shops_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/dashboard/rm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/handover/rm_handover_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/history/rm_history_screen.dart';

class RecoveryManShellController extends AppShellController {
  @override
  void onInit() {
    RecoveryManServicesBinding.ensureRegistered();
    super.onInit();
  }

  @override
  void selectLeaf(String id) {
    super.selectLeaf(id);
    _refreshLeafData(id);
  }

  void _refreshLeafData(String id) {
    switch (id) {
      case 'rm_dashboard':
        if (Get.isRegistered<RmDashboardController>()) {
          Get.find<RmDashboardController>().loadDashboard(force: true);
        }
        break;
      case 'rm_today_shops':
        if (Get.isRegistered<RmTodayShopsController>()) {
          Get.find<RmTodayShopsController>().loadShops(force: true);
        }
        break;
      case 'rm_history':
        if (Get.isRegistered<RmHistoryController>()) {
          Get.find<RmHistoryController>().loadHistory(force: true);
        }
        break;
      case 'rm_handover':
        if (Get.isRegistered<RmHandoverController>()) {
          Get.find<RmHandoverController>().loadHandover(force: true);
        }
        break;
    }
  }

  @override
  List<AppDrawerEntry> get drawerEntries => [
    AppDrawerEntry.leaf((
      id: 'rm_dashboard',
      icon: AppIcons.dashboard,
      label: AppTexts.navDashboard,
      screen: const RmDashboardScreen(),
      initBinding: () => RmDashboardBinding().dependencies(),
    )),
    AppDrawerEntry.group(
      AppDrawerGroup(
        id: 'rm_collections',
        icon: AppIcons.collections,
        label: AppTexts.navCollections,
        children: [
          (
            id: 'rm_today_shops',
            icon: AppIcons.shops,
            label: AppTexts.rmTodayShopsTitle,
            screen: const RmTodayShopsScreen(),
            initBinding: () => RmTodayShopsBinding().dependencies(),
          ),
          (
            id: 'rm_history',
            icon: AppIcons.history,
            label: AppTexts.navHistory,
            screen: const RmHistoryScreen(),
            initBinding: () => RmHistoryBinding().dependencies(),
          ),
        ],
      ),
    ),
    AppDrawerEntry.leaf((
      id: 'rm_handover',
      icon: AppIcons.handover,
      label: AppTexts.navHandover,
      screen: const RmHandoverScreen(),
      initBinding: () => RmHandoverBinding().dependencies(),
    )),
    AppDrawerEntry.leaf((
      id: 'rm_account',
      icon: AppIcons.account,
      label: AppTexts.navAccount,
      screen: const AccountScreen(),
      initBinding: () => AccountBinding().dependencies(),
    )),
  ];
}
