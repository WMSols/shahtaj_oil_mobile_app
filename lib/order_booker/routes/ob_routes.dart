import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/notes/ob_notes_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/visit/ob_order_create_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/orders/ob_order_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/tasks/ob_route_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/shops/ob_shop_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/shops/ob_shop_onboarding_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/shops/ob_shop_verify_on_site_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/history/ob_visit_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/notes/ob_notes_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/visit/ob_order_create_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/orders/ob_order_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/tasks/ob_route_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/shops/ob_shop_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/shops/ob_shop_onboarding_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/shops/ob_shop_verify_on_site_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/history/ob_visit_detail_screen.dart';

class OrderBookerRoutes {
  OrderBookerRoutes._();

  /// Pushed routes only. Shell leaves are embedded via [OrderBookerShellController]
  /// and are not registered here.
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.obRouteDetail,
      page: ObRouteDetailScreen.new,
      binding: ObRouteDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.obShopOnboarding,
      page: ObShopOnboardingScreen.new,
      binding: ObShopOnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.obShopVerifyOnSite,
      page: ObShopVerifyOnSiteScreen.new,
      binding: ObShopVerifyOnSiteBinding(),
    ),
    GetPage(
      name: AppRoutes.obShopDetail,
      page: ObShopDetailScreen.new,
      binding: ObShopDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.obOrderCreate,
      page: ObOrderCreateScreen.new,
      binding: ObOrderCreateBinding(),
    ),
    GetPage(
      name: AppRoutes.obNotes,
      page: ObNotesScreen.new,
      binding: ObNotesBinding(),
    ),
    GetPage(
      name: AppRoutes.obOrderDetail,
      page: ObOrderDetailScreen.new,
      binding: ObOrderDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.obVisitDetail,
      page: ObVisitDetailScreen.new,
      binding: ObVisitDetailBinding(),
    ),
  ];
}
