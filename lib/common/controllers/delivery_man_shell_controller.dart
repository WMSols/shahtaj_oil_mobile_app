import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_deliver_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_deliveries_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_orders_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_pickup_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_return_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_deliver_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_deliveries_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_orders_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_pickup_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_return_screen.dart';

class DeliveryManShellController extends AppShellController {
  @override
  List<AppDrawerEntry> get drawerEntries => [
    AppDrawerEntry.leaf((
      id: 'dm_dashboard',
      icon: AppIcons.dashboard,
      label: AppTexts.navDashboard,
      screen: const DmDashboardScreen(),
      initBinding: () => DmDashboardBinding().dependencies(),
    )),
    AppDrawerEntry.leaf((
      id: 'dm_orders',
      icon: AppIcons.invoices,
      label: AppTexts.navOrders,
      screen: const DmOrdersScreen(),
      initBinding: () => DmOrdersBinding().dependencies(),
    )),
    AppDrawerEntry.group(
      AppDrawerGroup(
        id: 'dm_deliveries',
        icon: AppIcons.deliveries,
        label: AppTexts.navDeliveries,
        children: [
          (
            id: 'dm_deliveries_list',
            icon: AppIcons.deliveries,
            label: AppTexts.navDeliveries,
            screen: const DmDeliveriesScreen(),
            initBinding: () => DmDeliveriesBinding().dependencies(),
          ),
          (
            id: 'dm_pickup',
            icon: AppIcons.inbox,
            label: AppTexts.dmPickupTitle,
            screen: const DmPickupScreen(),
            initBinding: () => DmPickupBinding().dependencies(),
          ),
          (
            id: 'dm_deliver',
            icon: AppIcons.check,
            label: AppTexts.dmDeliverTitle,
            screen: const DmDeliverScreen(),
            initBinding: () => DmDeliverBinding().dependencies(),
          ),
          (
            id: 'dm_return',
            icon: AppIcons.back,
            label: AppTexts.dmReturnTitle,
            screen: const DmReturnScreen(),
            initBinding: () => DmReturnBinding().dependencies(),
          ),
        ],
      ),
    ),
    AppDrawerEntry.leaf((
      id: 'dm_account',
      icon: AppIcons.account,
      label: AppTexts.navAccount,
      screen: const AccountScreen(),
      initBinding: () => AccountBinding().dependencies(),
    )),
  ];
}
