import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/collections/dm_collection_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/collections/dm_record_collection_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/collections/dm_shop_invoices_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/deliveries/dm_delivery_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/handover/dm_handover_confirm_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/handover/dm_handover_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/orders/dm_order_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/collections/dm_collection_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/collections/dm_record_collection_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/collections/dm_shop_invoices_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/deliveries/dm_delivery_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/handover/dm_handover_confirm_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/handover/dm_handover_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/orders/dm_order_detail_screen.dart';

class DeliveryManRoutes {
  DeliveryManRoutes._();

  /// Pushed routes only. Shell leaves are embedded via [DeliveryManShellController]
  /// and are not registered here.
  /// Static paths (confirm/record) must appear before `:id` routes.
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.dmOrderDetail,
      page: DmOrderDetailScreen.new,
      binding: DmOrderDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.dmDeliveryDetail,
      page: DmDeliveryDetailScreen.new,
      binding: DmDeliveryDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.dmShopOutstanding,
      page: DmShopInvoicesScreen.new,
      binding: DmShopInvoicesBinding(),
    ),
    GetPage(
      name: AppRoutes.dmRecordCollection,
      page: DmRecordCollectionScreen.new,
      binding: DmRecordCollectionBinding(),
    ),
    GetPage(
      name: AppRoutes.dmHandoverConfirm,
      page: DmHandoverConfirmScreen.new,
      binding: DmHandoverConfirmBinding(),
    ),
    GetPage(
      name: AppRoutes.dmCollectionDetail,
      page: DmCollectionDetailScreen.new,
      binding: DmCollectionDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.dmHandoverDetail,
      page: DmHandoverDetailScreen.new,
      binding: DmHandoverDetailBinding(),
    ),
  ];
}
