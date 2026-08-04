class AppRoutes {
  AppRoutes._();

  // Common
  static const splash = '/';
  static const selectRole = '/select-role';
  static const onboarding = '/onboarding';
  static const login = '/login';

  // Main shells
  static const orderBooker = '/order-booker';
  static const deliveryMan = '/delivery-man';
  static const recoveryMan = '/recovery-man';

  // Order booker (pushed / deep-linkable)
  static const obRouteDetail = '/order-booker/routes/:id';
  static const obShopOnboarding = '/order-booker/shops/onboarding';
  static const obShopDetail = '/order-booker/shops/:id';
  static const obShopVerifyOnSite = '/order-booker/verify-on-site';
  static const obOrderCreate = '/order-booker/orders/create';
  static const obOrderDetail = '/order-booker/orders/:id';
  static const obNotes = '/order-booker/notes';
  static const obVisitDetail = '/order-booker/visits/:id';

  // Delivery man (pushed / deep-linkable)
  static const dmOrderDetail = '/delivery-man/orders/:id';
  static const dmDeliveryDetail = '/delivery-man/deliveries/:id';
}
