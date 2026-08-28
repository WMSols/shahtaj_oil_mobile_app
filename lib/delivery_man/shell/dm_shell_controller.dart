import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/bindings/account/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/shell/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/collections/dm_collection_history_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/collections/dm_today_shops_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dashboard/dm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/deliver/dm_deliver_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/deliveries/dm_deliveries_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/handover/dm_handover_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/orders/dm_orders_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/pickup/dm_pickup_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/return/dm_return_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/van_stock/dm_van_stock_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_collection_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/handover/dm_handover_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/van_stock/dm_van_stock_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/collections/dm_collection_history_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/collections/dm_today_shops_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dashboard/dm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/deliver/dm_deliver_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/deliveries/dm_deliveries_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/handover/dm_handover_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/orders/dm_orders_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/pickup/dm_pickup_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/return/dm_return_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/van_stock/dm_van_stock_screen.dart';

class DeliveryManShellController extends AppShellController {
  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
  }

  @override
  void selectLeaf(String id) {
    super.selectLeaf(id);
    _refreshLeafData(id);
  }

  void _refreshLeafData(String id) {
    switch (id) {
      case 'dm_dashboard':
        if (Get.isRegistered<DmDashboardController>()) {
          Get.find<DmDashboardController>().load();
        }
        break;
      case 'dm_today_shops':
        if (Get.isRegistered<DmTodayShopsController>()) {
          Get.find<DmTodayShopsController>().loadShops(force: true);
        }
        break;
      case 'dm_collection_history':
        if (Get.isRegistered<DmCollectionHistoryController>()) {
          Get.find<DmCollectionHistoryController>().loadHistory(force: true);
        }
        break;
      case 'dm_handover':
        if (Get.isRegistered<DmHandoverController>()) {
          Get.find<DmHandoverController>().loadHandover(force: true);
        }
        break;
      case 'dm_van_stock':
        if (Get.isRegistered<DmVanStockController>()) {
          Get.find<DmVanStockController>().load();
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
            label: AppTexts.navOrders,
            screen: const DmOrdersScreen(),
            initBinding: () => DmOrdersBinding().dependencies(),
          ),
          (
            id: 'dm_deliver',
            icon: AppIcons.deliver,
            label: AppTexts.dmDeliverTitle,
            screen: const DmDeliverScreen(),
            initBinding: () => DmDeliverBinding().dependencies(),
          ),
          (
            id: 'dm_return',
            icon: AppIcons.returnDelivery,
            label: AppTexts.dmReturnTitle,
            screen: const DmReturnScreen(),
            initBinding: () => DmReturnBinding().dependencies(),
          ),
          (
            id: 'dm_deliveries_list',
            icon: AppIcons.history,
            label: AppTexts.navDeliveryHistory,
            screen: const DmDeliveriesScreen(),
            initBinding: () => DmDeliveriesBinding().dependencies(),
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
            icon: AppIcons.task,
            label: AppTexts.dmTodayShopsTitle,
            screen: const DmTodayShopsScreen(),
            initBinding: () => DmTodayShopsBinding().dependencies(),
          ),
          (
            id: 'dm_collection_history',
            icon: AppIcons.invoices,
            label: AppTexts.dmCollectionHistoryTitle,
            screen: const DmCollectionHistoryScreen(),
            initBinding: () => DmCollectionHistoryBinding().dependencies(),
          ),
        ],
      ),
    ),
    AppDrawerEntry.leaf((
      id: 'dm_handover',
      icon: AppIcons.handover,
      label: AppTexts.navHandover,
      screen: const DmHandoverScreen(),
      initBinding: () => DmHandoverBinding().dependencies(),
    )),
    AppDrawerEntry.leaf((
      id: 'dm_van_stock',
      icon: AppIcons.vanStock,
      label: AppTexts.dmVanStockTitle,
      screen: const DmVanStockScreen(),
      initBinding: () => DmVanStockBinding().dependencies(),
    )),
    AppDrawerEntry.leaf((
      id: 'dm_account',
      icon: AppIcons.account,
      label: AppTexts.navAccount,
      screen: const AccountScreen(),
      initBinding: () => AccountBinding().dependencies(),
    )),
  ];
}
