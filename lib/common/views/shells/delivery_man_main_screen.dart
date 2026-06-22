import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/delivery_man_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_deliveries_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_orders_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_deliveries_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_orders_screen.dart';

class DeliveryManMainScreen extends GetView<DeliveryManShellController> {
  const DeliveryManMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _ensureTabBindings();
    return PersistentTabView(
      backgroundColor: AppColors.white,
      onTabChanged: controller.setIndex,
      tabs: [
        PersistentTabConfig(
          screen: const DmDashboardScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.home),
            title: AppTexts.navDashboard,
            activeForegroundColor: AppColors.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const DmOrdersScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.invoice),
            title: AppTexts.navOrders,
            activeForegroundColor: AppColors.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const DmDeliveriesScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.document),
            title: AppTexts.navDeliveries,
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
    DmDashboardBinding().dependencies();
    DmOrdersBinding().dependencies();
    DmDeliveriesBinding().dependencies();
    AccountBinding().dependencies();
  }
}
