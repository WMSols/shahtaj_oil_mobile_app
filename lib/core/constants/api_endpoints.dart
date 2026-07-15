class ApiEndpoints {
  ApiEndpoints._();

  // Shared legacy placeholders (DM/RM still pending real APIs).
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

  // Order booker — Shahtaj v1 (all POST unless noted)
  static const obAuthLogin = '/api/shahtaj/v1/auth/login';
  static const obAuthMe = '/api/shahtaj/v1/auth/me';
  static const obTasksToday = '/api/shahtaj/v1/tasks/today';
  static const obTasksCheckIn = '/api/shahtaj/v1/tasks/check-in';
  static const obTasksSkip = '/api/shahtaj/v1/tasks/skip';
  static const obTasksNotes = '/api/shahtaj/v1/tasks/notes';
  static const obVisitsActive = '/api/shahtaj/v1/visits/active';
  static const obProductsList = '/api/shahtaj/v1/products/list';
  static const obVisitsLineAdd = '/api/shahtaj/v1/visits/line/add';
  static const obVisitsLineUpdate = '/api/shahtaj/v1/visits/line/update';
  static const obVisitsLineRemove = '/api/shahtaj/v1/visits/line/remove';
  static const obVisitsPlaceOrder = '/api/shahtaj/v1/visits/place-order';
  static const obVisitsEndWithoutOrder =
      '/api/shahtaj/v1/visits/end-without-order';
  static const obVisitsNotes = '/api/shahtaj/v1/visits/notes';
  static const obVisitsMine = '/api/shahtaj/v1/visits/mine';
  static const obVisitsGet = '/api/shahtaj/v1/visits/get';
  static const obScheduleWeekly = '/api/shahtaj/v1/schedule/weekly';
  static const obTargetsMine = '/api/shahtaj/v1/targets/mine';
  static const obShopsRegister = '/api/shahtaj/v1/shops/register';
  static const obShopsMine = '/api/shahtaj/v1/shops/mine';
  static const obShopsGet = '/api/shahtaj/v1/shops/get';
  static const obZonesList = '/api/shahtaj/v1/zones/list';
  static const obRoutesList = '/api/shahtaj/v1/routes/list';
  static const obPresenceHeartbeat = '/api/shahtaj/v1/presence/heartbeat';
}
