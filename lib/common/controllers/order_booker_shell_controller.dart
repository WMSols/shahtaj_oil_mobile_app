import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_history_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_my_shops_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_routes_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_shop_onboarding_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_history_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_my_shops_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_routes_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_shop_onboarding_screen.dart';

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
    AppDrawerEntry.leaf((
      id: 'ob_routes',
      icon: AppIcons.routes,
      label: AppTexts.navRoutes,
      screen: const ObRoutesScreen(),
      initBinding: () => ObRoutesBinding().dependencies(),
    )),
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
    AppDrawerEntry.leaf((
      id: 'ob_history',
      icon: AppIcons.history,
      label: AppTexts.navHistory,
      screen: const ObHistoryScreen(),
      initBinding: () => ObHistoryBinding().dependencies(),
    )),
    AppDrawerEntry.leaf((
      id: 'ob_account',
      icon: AppIcons.account,
      label: AppTexts.navAccount,
      screen: const AccountScreen(),
      initBinding: () => AccountBinding().dependencies(),
    )),
  ];
}
