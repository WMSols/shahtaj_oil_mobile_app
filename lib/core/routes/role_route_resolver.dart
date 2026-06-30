import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';

class RoleRouteResolver {
  RoleRouteResolver._();

  static String homeRoute(UserRole role) => switch (role) {
    UserRole.orderBooker => AppRoutes.orderBooker,
    UserRole.deliveryMan => AppRoutes.deliveryMan,
    UserRole.recoveryMan => AppRoutes.recoveryMan,
  };

  static void goToRoleHome(UserRole role) => Get.offAllNamed(homeRoute(role));
}
