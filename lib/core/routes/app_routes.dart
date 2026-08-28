class AppRoutes {
  AppRoutes._();

  // Common
  static const splash = '/';
  static const selectRole = '/select-role';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const reportProblem = '/account/report-problem';

  // Main shells
  static const orderBooker = '/order-booker';
  static const deliveryMan = '/delivery-man';

  // Order booker (pushed / deep-linkable)
  static const obRouteDetail = '/order-booker/routes/:id';
  static const obShopOnboarding = '/order-booker/shops/onboarding';
  static const obShopDetail = '/order-booker/shops/:id';
  static const obShopVerifyOnSite = '/order-booker/verify-on-site';
  static const obOrderCreate = '/order-booker/orders/create';
  static const obOrderDetail = '/order-booker/orders/:id';
  static const obNotes = '/order-booker/notes';
  static const obVisitDetail = '/order-booker/visits/:id';

  // Delivery man — deliveries (pushed / deep-linkable)
  static const dmOrderDetail = '/delivery-man/orders/:id';
  static const dmDeliveryDetail = '/delivery-man/deliveries/:id';

  // Delivery man — collections / handover (pushed / deep-linkable)
  static const dmShopOutstanding = '/delivery-man/shops/:id/outstanding';
  static const dmRecordCollection = '/delivery-man/collections/record';
  static const dmCollectionDetail = '/delivery-man/collections/:id';
  static const dmHandoverConfirm = '/delivery-man/handover/confirm';
  static const dmHandoverDetail = '/delivery-man/handover/:id';
}
