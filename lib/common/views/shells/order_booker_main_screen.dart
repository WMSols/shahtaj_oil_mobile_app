import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/order_booker_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_history_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_routes_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_shops_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_history_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_routes_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_shops_screen.dart';

class OrderBookerMainScreen extends GetView<OrderBookerShellController> {
  const OrderBookerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _ensureTabBindings();
    return PersistentTabView(
      backgroundColor: AppColors.white,
      onTabChanged: controller.setIndex,
      tabs: [
        PersistentTabConfig(
          screen: const ObDashboardScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.home),
            title: AppTexts.navDashboard,
            activeForegroundColor: AppColors.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const ObRoutesScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.location),
            title: AppTexts.navRoutes,
            activeForegroundColor: AppColors.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const ObShopsScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.clients),
            title: AppTexts.navShops,
            activeForegroundColor: AppColors.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const ObHistoryScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.document),
            title: AppTexts.navHistory,
            activeForegroundColor: AppColors.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const AccountScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.person),
            title: AppTexts.navAccount,
            activeForegroundColor: AppColors.primary,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }

  void _ensureTabBindings() {
    ObDashboardBinding().dependencies();
    ObRoutesBinding().dependencies();
    ObShopsBinding().dependencies();
    ObHistoryBinding().dependencies();
    AccountBinding().dependencies();
  }
}
