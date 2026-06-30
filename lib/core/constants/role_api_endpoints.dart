import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

/// Role-scoped API paths. Wire real Odoo endpoints here when backend is ready.
extension UserRoleApiX on UserRole {
  String get apiPrefix => switch (this) {
    UserRole.orderBooker => '/api/v1/order-booker',
    UserRole.deliveryMan => '/api/v1/delivery-man',
    UserRole.recoveryMan => '/api/v1/recovery-man',
  };

  String get authLoginPath => '$apiPrefix/auth/login';

  String get authLogoutPath => '$apiPrefix/auth/logout';

  String get authMePath => '$apiPrefix/auth/me';
}
