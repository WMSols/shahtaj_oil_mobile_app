import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_history_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_routes_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_shops_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_history_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_routes_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_shops_screen.dart';

class OrderBookerShellController extends AppShellController {
  @override
  List<AppDrawerItem> get drawerItems => [
    (
      icon: AppIcons.dashboard,
      label: AppTexts.navDashboard,
      screen: const ObDashboardScreen(),
      initBinding: () => ObDashboardBinding().dependencies(),
    ),
    (
      icon: AppIcons.routes,
      label: AppTexts.navRoutes,
      screen: const ObRoutesScreen(),
      initBinding: () => ObRoutesBinding().dependencies(),
    ),
    (
      icon: AppIcons.shops,
      label: AppTexts.navShops,
      screen: const ObShopsScreen(),
      initBinding: () => ObShopsBinding().dependencies(),
    ),
    (
      icon: AppIcons.history,
      label: AppTexts.navHistory,
      screen: const ObHistoryScreen(),
      initBinding: () => ObHistoryBinding().dependencies(),
    ),
    (
      icon: AppIcons.account,
      label: AppTexts.navAccount,
      screen: const AccountScreen(),
      initBinding: () => AccountBinding().dependencies(),
    ),
  ];
}
