import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dm_stock_item_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_dashboard_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_targets_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_zone_option.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/rm_targets_model.dart';

class AppMockData {
  AppMockData._();

  // ---------- Order Booker Dashboard ----------
  static ObDashboardModel get obDashboard => ObDashboardModel(
    todaysRoute: obTodaysRoute,
    recentOrders: obRecentOrders,
    targets: obTargets,
  );

  static ObRouteModel get obTodaysRoute => const ObRouteModel(
    id: 'route-ob-001',
    name: 'Gulberg Route A',
    shopCount: 12,
    distanceKm: 8.4,
    status: RouteStatus.inProgress,
  );

  static ObTargetsModel get obTargets =>
      const ObTargetsModel(ordersCurrent: 8, ordersTarget: 15);

  // ---------- Delivery Man Dashboard ----------
  static List<DmStockItemModel> get dmStockItems => const [
    DmStockItemModel(
      id: 'stock-001',
      name: 'Premium Cooking Oil',
      quantity: 45,
      unit: '5L',
      isLowStock: true,
      imageAsset: AppImages.onboardingIntro,
    ),
    DmStockItemModel(
      id: 'stock-002',
      name: 'Banaspati Ghee',
      quantity: 120,
      unit: '16kg',
      imageAsset: AppImages.onboardingLanguage,
    ),
    DmStockItemModel(
      id: 'stock-003',
      name: 'Vegetable Oil',
      quantity: 12,
      unit: '1L',
      isLowStock: true,
      imageAsset: AppImages.onboardingRole,
    ),
  ];

  static int get dmVanStockCount => 24;

  // ---------- Recovery Man Dashboard ----------
  static RmTargetsModel get rmTargets =>
      const RmTargetsModel(recoveryCurrent: 45000, recoveryTarget: 80000);

  static List<ObOrderSummaryModel> get obRecentOrders => const [
    ObOrderSummaryModel(
      id: 'ord-5521',
      orderNumber: '#ORD-5521',
      shopName: 'Al-Madina Store',
      amount: 12450,
      status: OrderStatus.delivered,
    ),
    ObOrderSummaryModel(
      id: 'ord-5518',
      orderNumber: '#ORD-5518',
      shopName: 'Green Valley Grocery',
      amount: 8200,
      status: OrderStatus.submitted,
    ),
    ObOrderSummaryModel(
      id: 'ord-5515',
      orderNumber: '#ORD-5515',
      shopName: 'Metro Daily Express',
      amount: 15000,
      status: OrderStatus.draft,
    ),
  ];

  // ---------- Order Booker Shops ----------
  static List<ObZoneOption> get obZones => const [
    ObZoneOption(id: 1, name: 'Gulberg Zone'),
    ObZoneOption(id: 2, name: 'Model Town Zone'),
    ObZoneOption(id: 3, name: 'DHA Zone'),
  ];

  static List<ObRouteOption> get obRoutes => const [
    ObRouteOption(id: 1, zoneId: 1, name: 'Gulberg Route A'),
    ObRouteOption(id: 2, zoneId: 1, name: 'Gulberg Route B'),
    ObRouteOption(id: 3, zoneId: 2, name: 'Model Town B'),
    ObRouteOption(id: 4, zoneId: 3, name: 'DHA Phase 5'),
  ];

  static List<ObShopModel> get obShops => const [
    ObShopModel(
      id: 'shop-001',
      name: 'Al-Madina General Store',
      ownerName: 'Muhammad Ahmed',
      phone: '0300-1234567',
      locationLabel: 'Zone B-12',
      zoneName: 'South-01',
      routeName: 'Gulberg III - Main',
      creditLimit: 50000,
      legacyBalance: 12500,
      latitude: 31.5204,
      longitude: 74.3587,
      heroImageAsset: AppImages.onboardingIntro,
      verificationPhotos: ObShopVerificationPhotos(
        cnicFront: AppImages.onboardingLanguage,
        cnicBack: AppImages.onboardingRole,
        ownerPhoto: AppImages.selectRoleOrderBooker,
        shopExterior: AppImages.onboardingIntro,
      ),
      status: ShopStatus.pending,
      isHighlighted: true,
    ),
    ObShopModel(
      id: 'shop-002',
      name: 'Green Valley Grocery',
      ownerName: 'Hassan Raza',
      phone: '0321-9876543',
      locationLabel: 'Model Town Market',
      zoneName: 'Model Town Zone',
      routeName: 'Model Town B',
      creditLimit: 35000,
      legacyBalance: 4200,
      latitude: 31.4825,
      longitude: 74.3231,
      heroImageAsset: AppImages.onboardingLanguage,
      verificationPhotos: ObShopVerificationPhotos(
        cnicFront: AppImages.onboardingIntro,
        cnicBack: AppImages.onboardingLanguage,
        ownerPhoto: AppImages.selectRoleDeliveryMan,
        shopExterior: AppImages.onboardingLanguage,
      ),
      status: ShopStatus.approved,
    ),
    ObShopModel(
      id: 'shop-003',
      name: 'Metro Daily Express',
      ownerName: 'Ali Khan',
      phone: '0333-5551212',
      locationLabel: 'Route 7',
      zoneName: 'Gulberg Zone',
      routeName: 'Gulberg Route A',
      creditLimit: 75000,
      legacyBalance: 0,
      latitude: 31.5497,
      longitude: 74.3436,
      heroImageAsset: AppImages.onboardingRole,
      verificationPhotos: ObShopVerificationPhotos(
        cnicFront: AppImages.onboardingRole,
        cnicBack: AppImages.onboardingIntro,
        ownerPhoto: AppImages.selectRoleRecoveryMan,
        shopExterior: AppImages.onboardingRole,
      ),
      status: ShopStatus.active,
    ),
    ObShopModel(
      id: 'shop-004',
      name: 'City Mart & Co.',
      ownerName: 'Usman Tariq',
      phone: '0345-1112233',
      locationLabel: 'Invalid Doc',
      zoneName: 'DHA Zone',
      routeName: 'DHA Phase 5',
      creditLimit: 20000,
      legacyBalance: 8900,
      latitude: 31.4697,
      longitude: 74.2728,
      heroImageAsset: AppImages.selectRoleOrderBooker,
      verificationPhotos: ObShopVerificationPhotos(
        cnicFront: AppImages.selectRoleOrderBooker,
        cnicBack: AppImages.selectRoleDeliveryMan,
        ownerPhoto: AppImages.selectRoleOrderBooker,
        shopExterior: AppImages.selectRoleOrderBooker,
      ),
      status: ShopStatus.rejected,
    ),
    ObShopModel(
      id: 'shop-005',
      name: 'Sunrise Provision Store',
      ownerName: 'Bilal Hussain',
      phone: '0302-7788990',
      locationLabel: 'DHA Phase 4',
      zoneName: 'DHA Zone',
      routeName: 'DHA Phase 5',
      creditLimit: 40000,
      legacyBalance: 6100,
      latitude: 31.4590,
      longitude: 74.2663,
      heroImageAsset: AppImages.selectRoleDeliveryMan,
      verificationPhotos: ObShopVerificationPhotos(
        cnicFront: AppImages.selectRoleRecoveryMan,
        cnicBack: AppImages.selectRoleOrderBooker,
        ownerPhoto: AppImages.selectRoleDeliveryMan,
        shopExterior: AppImages.selectRoleDeliveryMan,
      ),
      status: ShopStatus.pending,
    ),
  ];
}
