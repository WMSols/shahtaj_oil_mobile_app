import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

/// Role-scoped API paths.
/// Order Booker uses Shahtaj v1; DM/RM remain placeholders until APIs exist.
extension UserRoleApiX on UserRole {
  String get apiPrefix => switch (this) {
    UserRole.orderBooker => '/api/shahtaj/v1',
    UserRole.deliveryMan => '/api/v1/delivery-man',
    UserRole.recoveryMan => '/api/v1/recovery-man',
  };

  String get authLoginPath => switch (this) {
    UserRole.orderBooker => ApiEndpoints.obAuthLogin,
    _ => '$apiPrefix/auth/login',
  };

  String get authLogoutPath => '$apiPrefix/auth/logout';

  String get authMePath => switch (this) {
    UserRole.orderBooker => ApiEndpoints.obAuthMe,
    _ => '$apiPrefix/auth/me',
  };
}
