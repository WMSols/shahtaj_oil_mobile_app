import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/bindings/account/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/shell/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/collections/dm_collection_history_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/collections/dm_today_shops_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dashboard/dm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/free_deliver/dm_free_deliver_search_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/orders/dm_orders_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/pickup/dm_pickup_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/van_stock/dm_van_stock_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/wallet/dm_wallet_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_collection_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/free_deliver/dm_free_deliver_search_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_orders_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/pickup/dm_pickup_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/van_stock/dm_van_stock_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/wallet/dm_wallet_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/sync/dm_day_bootstrap_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/collections/dm_collection_history_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/collections/dm_today_shops_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dashboard/dm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/free_deliver/dm_free_deliver_search_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/orders/dm_orders_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/pickup/dm_pickup_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/van_stock/dm_van_stock_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/wallet/dm_wallet_screen.dart';

class DeliveryManShellController extends AppShellController {
  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    if (Get.isRegistered<DmDayBootstrapService>()) {
      Get.find<DmDayBootstrapService>().runInBackground(force: true);
    }
  }

  @override
  void selectLeaf(String id) {
    super.selectLeaf(id);
    _refreshLeafData(id);
  }

  void _refreshLeafData(String id) {
    final forceNetwork = Get.isRegistered<ConnectivityService>()
        ? Get.find<ConnectivityService>().isOnline.value &&
              Get.find<ConnectivityService>().quality.value !=
                  NetworkQuality.weak
        : true;

    switch (id) {
      case 'dm_dashboard':
        if (Get.isRegistered<DmDashboardController>()) {
          Get.find<DmDashboardController>().load(force: forceNetwork);
        }
        break;
      case 'dm_pickup':
        if (Get.isRegistered<DmPickupController>()) {
          Get.find<DmPickupController>().loadToday(force: forceNetwork);
        }
        break;
      case 'dm_orders':
        if (Get.isRegistered<DmOrdersController>()) {
          Get.find<DmOrdersController>().loadPlan(force: forceNetwork);
        }
        break;
      case 'dm_free_deliver':
        if (Get.isRegistered<DmFreeDeliverSearchController>() && forceNetwork) {
          Get.find<DmFreeDeliverSearchController>().search();
        }
        break;
      case 'dm_van_stock':
        if (Get.isRegistered<DmVanStockController>()) {
          Get.find<DmVanStockController>().load(force: forceNetwork);
        }
        break;
      case 'dm_today_shops':
        if (Get.isRegistered<DmTodayShopsController>()) {
          Get.find<DmTodayShopsController>().loadShops(force: forceNetwork);
        }
        break;
      case 'dm_wallet':
        if (Get.isRegistered<DmWalletController>()) {
          Get.find<DmWalletController>().load(force: forceNetwork);
        }
        break;
      case 'dm_collection_history':
        if (Get.isRegistered<DmCollectionHistoryController>()) {
          Get.find<DmCollectionHistoryController>().loadHistory(
            force: forceNetwork,
          );
        }
        break;
    }
  }

  @override
  List<AppDrawerEntry> get drawerEntries => [
    AppDrawerEntry.leaf((
      id: 'dm_dashboard',
      icon: AppIcons.dashboard,
      label: AppTexts.navDashboard,
      screen: const DmDashboardScreen(),
      initBinding: () => DmDashboardBinding().dependencies(),
    )),
    AppDrawerEntry.group(
      AppDrawerGroup(
        id: 'dm_deliveries',
        icon: AppIcons.deliveries,
        label: AppTexts.navDeliveries,
        children: [
          (
            id: 'dm_pickup',
            icon: AppIcons.pickups,
            label: AppTexts.dmPickupTitle,
            screen: const DmPickupScreen(),
            initBinding: () => DmPickupBinding().dependencies(),
          ),
          (
            id: 'dm_orders',
            icon: AppIcons.orders,
            label: AppTexts.dmTodayPlanTitle,
            screen: const DmOrdersScreen(),
            initBinding: () => DmOrdersBinding().dependencies(),
          ),
          (
            id: 'dm_free_deliver',
            icon: AppIcons.addshop,
            label: AppTexts.dmFreeDeliverTitle,
            screen: const DmFreeDeliverSearchScreen(),
            initBinding: () => DmFreeDeliverSearchBinding().dependencies(),
          ),
          (
            id: 'dm_van_stock',
            icon: AppIcons.vanStock,
            label: AppTexts.dmVanStockTitle,
            screen: const DmVanStockScreen(),
            initBinding: () => DmVanStockBinding().dependencies(),
          ),
        ],
      ),
    ),
    AppDrawerEntry.group(
      AppDrawerGroup(
        id: 'dm_collections',
        icon: AppIcons.collections,
        label: AppTexts.navCollections,
        children: [
          (
            id: 'dm_today_shops',
            icon: AppIcons.shops,
            label: AppTexts.dmRecoverShopsTitle,
            screen: const DmTodayShopsScreen(),
            initBinding: () => DmTodayShopsBinding().dependencies(),
          ),
          (
            id: 'dm_wallet',
            icon: AppIcons.wallet,
            label: AppTexts.dmWalletTitle,
            screen: const DmWalletScreen(),
            initBinding: () => DmWalletBinding().dependencies(),
          ),
          (
            id: 'dm_collection_history',
            icon: AppIcons.history,
            label: AppTexts.dmCollectionHistoryTitle,
            screen: const DmCollectionHistoryScreen(),
            initBinding: () => DmCollectionHistoryBinding().dependencies(),
          ),
        ],
      ),
    ),
    // Handover / delivery history / mock deliver-return: still no API.
    AppDrawerEntry.leaf((
      id: 'dm_account',
      icon: AppIcons.account,
      label: AppTexts.navAccount,
      screen: const AccountScreen(),
      initBinding: () => AccountBinding().dependencies(),
    )),
  ];
}
