import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_collections_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_handover_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_handover_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_record_collection_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/rm_shop_invoices_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_collections_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_handover_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_handover_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_record_collection_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/rm_shop_invoices_screen.dart';

class RecoveryManRoutes {
  RecoveryManRoutes._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.rmDashboard,
      page: RmDashboardScreen.new,
      binding: RmDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.rmCollections,
      page: RmCollectionsScreen.new,
      binding: RmCollectionsBinding(),
    ),
    GetPage(
      name: AppRoutes.rmShopInvoices,
      page: RmShopInvoicesScreen.new,
      binding: RmShopInvoicesBinding(),
    ),
    GetPage(
      name: AppRoutes.rmRecordCollection,
      page: RmRecordCollectionScreen.new,
      binding: RmRecordCollectionBinding(),
    ),
    GetPage(
      name: AppRoutes.rmHandover,
      page: RmHandoverScreen.new,
      binding: RmHandoverBinding(),
    ),
    GetPage(
      name: AppRoutes.rmHandoverDetail,
      page: RmHandoverDetailScreen.new,
      binding: RmHandoverDetailBinding(),
    ),
  ];
}
