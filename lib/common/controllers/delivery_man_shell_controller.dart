import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_deliveries_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_orders_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_deliveries_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_orders_screen.dart';

class DeliveryManShellController extends AppShellController {
  @override
  List<AppDrawerItem> get drawerItems => [
    (
      icon: AppIcons.dashboard,
      label: AppTexts.navDashboard,
      screen: const DmDashboardScreen(),
      initBinding: () => DmDashboardBinding().dependencies(),
    ),
    (
      icon: AppIcons.invoices,
      label: AppTexts.navOrders,
      screen: const DmOrdersScreen(),
      initBinding: () => DmOrdersBinding().dependencies(),
    ),
    (
      icon: AppIcons.deliveries,
      label: AppTexts.navDeliveries,
      screen: const DmDeliveriesScreen(),
      initBinding: () => DmDeliveriesBinding().dependencies(),
    ),
    (
      icon: AppIcons.account,
      label: AppTexts.navAccount,
      screen: const AccountScreen(),
      initBinding: () => AccountBinding().dependencies(),
    ),
  ];
}
