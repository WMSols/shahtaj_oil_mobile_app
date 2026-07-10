class AppRoutes {
  AppRoutes._();

  // Common
  static const splash = '/';
  static const selectRole = '/select-role';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const account = '/account';

  // Main shells
  static const orderBooker = '/order-booker';
  static const deliveryMan = '/delivery-man';
  static const recoveryMan = '/recovery-man';

  // Order booker
  static const obDashboard = '/order-booker/dashboard';
  static const obWeeklySchedule = '/order-booker/schedule/weekly';
  static const obRouteDetail = '/order-booker/routes/:id';
  static const obShopOnboarding = '/order-booker/shops/onboarding';
  static const obMyShops = '/order-booker/my-shops';
  static const obShopDetail = '/order-booker/shops/:id';
  static const obShopEdit = '/order-booker/shops/:id/edit';
  static const obCheckIn = '/order-booker/check-in';
  static const obActiveVisit = '/order-booker/visits/active';
  static const obTargets = '/order-booker/targets';
  static const obOrderCreate = '/order-booker/orders/create';
  static const obOrderDetail = '/order-booker/orders/:id';
  static const obHistory = '/order-booker/history';
  static const obVisitDetail = '/order-booker/visits/:id';

  // Delivery man
  static const dmDashboard = '/delivery-man/dashboard';
  static const dmOrders = '/delivery-man/orders';
  static const dmOrderDetail = '/delivery-man/orders/:id';
  static const dmPickup = '/delivery-man/pickup';
  static const dmDeliver = '/delivery-man/deliver';
  static const dmDeliveries = '/delivery-man/deliveries';
  static const dmDeliveryDetail = '/delivery-man/deliveries/:id';
  static const dmReturn = '/delivery-man/return';

  // Recovery man
  static const rmDashboard = '/recovery-man/dashboard';
  static const rmCollections = '/recovery-man/collections';
  static const rmShopInvoices = '/recovery-man/shop-invoices';
  static const rmRecordCollection = '/recovery-man/record-collection';
  static const rmHandover = '/recovery-man/handover';
  static const rmHandoverDetail = '/recovery-man/handover/:id';
}
