import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/routes/common_routes.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/routes/dm_routes.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/routes/ob_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    ...CommonRoutes.pages,
    ...OrderBookerRoutes.pages,
    ...DeliveryManRoutes.pages,
  ];
}
