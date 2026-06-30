import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/bindings/account_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/bindings/auth_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/bindings/delivery_man_shell_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/bindings/onboarding_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/bindings/order_booker_shell_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/bindings/recovery_man_shell_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/bindings/select_role_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/bindings/splash_binding.dart';
import 'package:shahtaj_oil_mobile_app/common/views/account/account_screen.dart';
import 'package:shahtaj_oil_mobile_app/common/views/auth/login_screen.dart';
import 'package:shahtaj_oil_mobile_app/common/views/onboarding/onboarding_screen.dart';
import 'package:shahtaj_oil_mobile_app/common/views/select_role/select_role_screen.dart';
import 'package:shahtaj_oil_mobile_app/common/views/splash/splash_screen.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/delivery_man_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/order_booker_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/recovery_man_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_shell.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';

class CommonRoutes {
  CommonRoutes._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: SplashScreen.new,
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.selectRole,
      page: SelectRoleScreen.new,
      binding: SelectRoleBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: OnboardingScreen.new,
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: LoginScreen.new,
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.account,
      page: AccountScreen.new,
      binding: AccountBinding(),
    ),
    GetPage(
      name: AppRoutes.orderBooker,
      page: () => const AppShell<OrderBookerShellController>(),
      binding: OrderBookerShellBinding(),
    ),
    GetPage(
      name: AppRoutes.deliveryMan,
      page: () => const AppShell<DeliveryManShellController>(),
      binding: DeliveryManShellBinding(),
    ),
    GetPage(
      name: AppRoutes.recoveryMan,
      page: () => const AppShell<RecoveryManShellController>(),
      binding: RecoveryManShellBinding(),
    ),
  ];
}
