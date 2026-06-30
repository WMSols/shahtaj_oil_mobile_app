import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_collections_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_handover_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_collections_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_handover_screen.dart';

class RecoveryManShellController extends AppShellController {
  @override
  List<AppDrawerItem> get drawerItems => [
    (
      icon: AppIcons.dashboard,
      label: AppTexts.navDashboard,
      screen: const RmDashboardScreen(),
      initBinding: () => RmDashboardBinding().dependencies(),
    ),
    (
      icon: AppIcons.collections,
      label: AppTexts.navCollections,
      screen: const RmCollectionsScreen(),
      initBinding: () => RmCollectionsBinding().dependencies(),
    ),
    (
      icon: AppIcons.handover,
      label: AppTexts.navHandover,
      screen: const RmHandoverScreen(),
      initBinding: () => RmHandoverBinding().dependencies(),
    ),
    (
      icon: AppIcons.account,
      label: AppTexts.navAccount,
      screen: const AccountScreen(),
      initBinding: () => AccountBinding().dependencies(),
    ),
  ];
}
