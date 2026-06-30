class ApiEndpoints {
  ApiEndpoints._();

  // Shared feature paths (role modules may prefix via UserRole.apiPrefix later).
  // Role-specific auth paths live in role_api_endpoints.dart.
  static const authLogin = '/api/v1/auth/login';
  static const authLogout = '/api/v1/auth/logout';
  static const authMe = '/api/v1/auth/me';

  static const shops = '/api/v1/shops';
  static String shop(String id) => '/api/v1/shops/$id';

  static const routes = '/api/v1/routes';
  static String route(String id) => '/api/v1/routes/$id';

  static const visits = '/api/v1/visits';
  static String visit(String id) => '/api/v1/visits/$id';

  static const orders = '/api/v1/orders';
  static String order(String id) => '/api/v1/orders/$id';

  static const deliveries = '/api/v1/deliveries';
  static String delivery(String id) => '/api/v1/deliveries/$id';

  static const pickups = '/api/v1/pickups';
  static const returns = '/api/v1/returns';

  static const invoices = '/api/v1/invoices';
  static String invoice(String id) => '/api/v1/invoices/$id';

  static const collections = '/api/v1/collections';
  static String collection(String id) => '/api/v1/collections/$id';

  static const handovers = '/api/v1/handovers';
  static String handover(String id) => '/api/v1/handovers/$id';
}
