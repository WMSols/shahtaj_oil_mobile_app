import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_collections_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_handover_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_record_collection_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_shop_invoices_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_collections_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_handover_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_record_collection_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_shop_invoices_screen.dart';

class RecoveryManShellController extends AppShellController {
  @override
  List<AppDrawerEntry> get drawerEntries => [
    AppDrawerEntry.leaf((
      id: 'rm_dashboard',
      icon: AppIcons.dashboard,
      label: AppTexts.navDashboard,
      screen: const RmDashboardScreen(),
      initBinding: () => RmDashboardBinding().dependencies(),
    )),
    AppDrawerEntry.group(
      AppDrawerGroup(
        id: 'rm_collections',
        icon: AppIcons.collections,
        label: AppTexts.navCollections,
        children: [
          (
            id: 'rm_collections_list',
            icon: AppIcons.collections,
            label: AppTexts.navCollections,
            screen: const RmCollectionsScreen(),
            initBinding: () => RmCollectionsBinding().dependencies(),
          ),
          (
            id: 'rm_shop_invoices',
            icon: AppIcons.invoices,
            label: AppTexts.rmShopInvoicesTitle,
            screen: const RmShopInvoicesScreen(),
            initBinding: () => RmShopInvoicesBinding().dependencies(),
          ),
          (
            id: 'rm_record_collection',
            icon: AppIcons.add,
            label: AppTexts.rmRecordCollectionTitle,
            screen: const RmRecordCollectionScreen(),
            initBinding: () => RmRecordCollectionBinding().dependencies(),
          ),
        ],
      ),
    ),
    AppDrawerEntry.leaf((
      id: 'rm_handover',
      icon: AppIcons.handover,
      label: AppTexts.navHandover,
      screen: const RmHandoverScreen(),
      initBinding: () => RmHandoverBinding().dependencies(),
    )),
    AppDrawerEntry.leaf((
      id: 'rm_account',
      icon: AppIcons.account,
      label: AppTexts.navAccount,
      screen: const AccountScreen(),
      initBinding: () => AccountBinding().dependencies(),
    )),
  ];
}
