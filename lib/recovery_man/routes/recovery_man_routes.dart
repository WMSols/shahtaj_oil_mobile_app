import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/collections/rm_collection_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/collections/rm_record_collection_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/collections/rm_shop_invoices_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/handover/rm_handover_confirm_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/bindings/handover/rm_handover_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/collections/rm_collection_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/collections/rm_record_collection_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/collections/rm_shop_invoices_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/handover/rm_handover_confirm_screen.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/views/handover/rm_handover_detail_screen.dart';

class RecoveryManRoutes {
  RecoveryManRoutes._();

  /// Pushed routes only. Shell leaves are embedded via [RecoveryManShellController].
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.rmShopOutstanding,
      page: RmShopInvoicesScreen.new,
      binding: RmShopInvoicesBinding(),
    ),
    GetPage(
      name: AppRoutes.rmRecordCollection,
      page: RmRecordCollectionScreen.new,
      binding: RmRecordCollectionBinding(),
    ),
    GetPage(
      name: AppRoutes.rmCollectionDetail,
      page: RmCollectionDetailScreen.new,
      binding: RmCollectionDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.rmHandoverConfirm,
      page: RmHandoverConfirmScreen.new,
      binding: RmHandoverConfirmBinding(),
    ),
    GetPage(
      name: AppRoutes.rmHandoverDetail,
      page: RmHandoverDetailScreen.new,
      binding: RmHandoverDetailBinding(),
    ),
  ];
}
