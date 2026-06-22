import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/routes/common_routes.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/routes/delivery_man_routes.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/routes/order_booker_routes.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/routes/recovery_man_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    ...CommonRoutes.pages,
    ...OrderBookerRoutes.pages,
    ...DeliveryManRoutes.pages,
    ...RecoveryManRoutes.pages,
  ];
}
