class ApiEndpoints {
  ApiEndpoints._();

  // Order booker — Shahtaj v1 (all POST unless noted)
  static const obAuthLogin = '/api/shahtaj/v1/auth/login';
  static const obAuthMe = '/api/shahtaj/v1/auth/me';
  static const obTasksToday = '/api/shahtaj/v1/tasks/today';
  static const obTasksCheckIn = '/api/shahtaj/v1/tasks/check-in';
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
  static const obShopsVerifyOnSite = '/api/shahtaj/v1/shops/verify-on-site';
  static const obZonesList = '/api/shahtaj/v1/zones/list';
  static const obRoutesList = '/api/shahtaj/v1/routes/list';
  static const obPresenceHeartbeat = '/api/shahtaj/v1/presence/heartbeat';
}
