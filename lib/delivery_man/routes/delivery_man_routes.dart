import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_deliver_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_deliveries_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_delivery_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_order_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_orders_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_pickup_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/bindings/dm_return_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_deliver_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_deliveries_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_delivery_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_order_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_orders_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_pickup_screen.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/views/dm_return_screen.dart';

class DeliveryManRoutes {
  DeliveryManRoutes._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.dmDashboard,
      page: DmDashboardScreen.new,
      binding: DmDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.dmOrders,
      page: DmOrdersScreen.new,
      binding: DmOrdersBinding(),
    ),
    GetPage(
      name: AppRoutes.dmOrderDetail,
      page: DmOrderDetailScreen.new,
      binding: DmOrderDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.dmPickup,
      page: DmPickupScreen.new,
      binding: DmPickupBinding(),
    ),
    GetPage(
      name: AppRoutes.dmDeliver,
      page: DmDeliverScreen.new,
      binding: DmDeliverBinding(),
    ),
    GetPage(
      name: AppRoutes.dmDeliveries,
      page: DmDeliveriesScreen.new,
      binding: DmDeliveriesBinding(),
    ),
    GetPage(
      name: AppRoutes.dmDeliveryDetail,
      page: DmDeliveryDetailScreen.new,
      binding: DmDeliveryDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.dmReturn,
      page: DmReturnScreen.new,
      binding: DmReturnBinding(),
    ),
  ];
}
