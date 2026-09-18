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

  // Delivery man — Shahtaj v1 (all POST)
  static const dmAuthLogin = '/api/shahtaj/v1/dm/auth/login';
  static const dmAuthMe = '/api/shahtaj/v1/dm/auth/me';
  static const dmPresenceHeartbeat = '/api/shahtaj/v1/dm/presence/heartbeat';
  static const dmSessionGet = '/api/shahtaj/v1/dm/session/get';
  static const dmSessionDepart = '/api/shahtaj/v1/dm/session/depart';
  static const dmSessionEnd = '/api/shahtaj/v1/dm/session/end';
  static const dmLoadToday = '/api/shahtaj/v1/dm/load/today';
  static const dmLoadPick = '/api/shahtaj/v1/dm/load/pick';
  static const dmJobPick = '/api/shahtaj/v1/dm/job/pick';
  static const dmVanSnapshot = '/api/shahtaj/v1/dm/van/snapshot';
  static const dmVanProducts = '/api/shahtaj/v1/dm/van/products';
  static const dmVanLoad = '/api/shahtaj/v1/dm/van/load';
  static const dmVanReturn = '/api/shahtaj/v1/dm/van/return';
  static const dmPlanToday = '/api/shahtaj/v1/dm/plan/today';
  static const dmPlanJob = '/api/shahtaj/v1/dm/plan/job';
  static const dmJobNotes = '/api/shahtaj/v1/dm/job/notes';
  static const dmJobShopClosed = '/api/shahtaj/v1/dm/job/shop-closed';
  static const dmJobFailed = '/api/shahtaj/v1/dm/job/failed';
  static const dmJobDeliver = '/api/shahtaj/v1/dm/job/deliver';
  static const dmJobReturnUndelivered =
      '/api/shahtaj/v1/dm/job/return-undelivered';
  static const dmShopsSearch = '/api/shahtaj/v1/dm/shops/search';
  static const dmDeliverFree = '/api/shahtaj/v1/dm/deliver/free';
  static const dmRecoveryShop = '/api/shahtaj/v1/dm/recovery/shop';
  static const dmRecoveryCollect = '/api/shahtaj/v1/dm/recovery/collect';
  static const dmWalletGet = '/api/shahtaj/v1/dm/wallet/get';
  static const dmWalletCollections = '/api/shahtaj/v1/dm/wallet/collections';
}
