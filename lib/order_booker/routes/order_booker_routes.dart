import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_check_in_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_dashboard_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_history_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_my_shops_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_active_visit_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_order_create_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_order_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_route_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_shop_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_shop_onboarding_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_targets_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_visit_detail_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_weekly_schedule_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_active_visit_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_check_in_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_dashboard_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_history_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_my_shops_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_order_create_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_order_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_route_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_shop_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_shop_onboarding_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_targets_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_visit_detail_screen.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/views/ob_weekly_schedule_screen.dart';

class OrderBookerRoutes {
  OrderBookerRoutes._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.obDashboard,
      page: ObDashboardScreen.new,
      binding: ObDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.obWeeklySchedule,
      page: ObWeeklyScheduleScreen.new,
      binding: ObWeeklyScheduleBinding(),
    ),
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
      name: AppRoutes.obMyShops,
      page: ObMyShopsScreen.new,
      binding: ObMyShopsBinding(),
    ),
    GetPage(
      name: AppRoutes.obShopDetail,
      page: ObShopDetailScreen.new,
      binding: ObShopDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.obShopEdit,
      page: ObShopOnboardingScreen.new,
      binding: ObShopOnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.obCheckIn,
      page: ObCheckInScreen.new,
      binding: ObCheckInBinding(),
    ),
    GetPage(
      name: AppRoutes.obActiveVisit,
      page: ObActiveVisitScreen.new,
      binding: ObActiveVisitBinding(),
    ),
    GetPage(
      name: AppRoutes.obTargets,
      page: ObTargetsScreen.new,
      binding: ObTargetsBinding(),
    ),
    GetPage(
      name: AppRoutes.obOrderCreate,
      page: ObOrderCreateScreen.new,
      binding: ObOrderCreateBinding(),
    ),
    GetPage(
      name: AppRoutes.obOrderDetail,
      page: ObOrderDetailScreen.new,
      binding: ObOrderDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.obHistory,
      page: ObHistoryScreen.new,
      binding: ObHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.obVisitDetail,
      page: ObVisitDetailScreen.new,
      binding: ObVisitDetailBinding(),
    ),
  ];
}
