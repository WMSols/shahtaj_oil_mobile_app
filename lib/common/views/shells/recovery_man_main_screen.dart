import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/recovery_man_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_collections_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_handover_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_collections_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_handover_screen.dart';

class RecoveryManMainScreen extends GetView<RecoveryManShellController> {
  const RecoveryManMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _ensureTabBindings();
    return PersistentTabView(
      backgroundColor: AppColors.white,
      onTabChanged: controller.setIndex,
      tabs: [
        PersistentTabConfig(
          screen: const RmDashboardScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.home),
            title: AppTexts.navDashboard,
            activeForegroundColor: AppColors.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const RmCollectionsScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.invoice),
            title: AppTexts.navCollections,
            activeForegroundColor: AppColors.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const RmHandoverScreen(),
          item: ItemConfig(
            icon: const Icon(AppIcons.upload),
            title: AppTexts.navHandover,
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
    RmDashboardBinding().dependencies();
    RmCollectionsBinding().dependencies();
    RmHandoverBinding().dependencies();
    AccountBinding().dependencies();
  }
}
