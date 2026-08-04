import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/deliveries/dm_delivery_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/orders/dm_order_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/deliveries/dm_delivery_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/orders/dm_order_detail_screen.dart';

class DeliveryManRoutes {
  DeliveryManRoutes._();

  /// Pushed routes only. Shell leaves are embedded via [DeliveryManShellController]
  /// and are not registered here.
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
  ];
}
