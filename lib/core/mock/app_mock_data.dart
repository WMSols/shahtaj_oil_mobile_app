import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dm_stock_item_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_dashboard_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_targets_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_zone_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_product_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';
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
    name: 'I-10 Wholesale Market Route A',
    shopCount: 5,
    distanceKm: 6.2,
    status: RouteStatus.inProgress,
  );

  // ---------- Order Booker Today's Tasks ----------
  static List<ObTaskModel> get obTodayTasks => const [
    ObTaskModel(
      id: 1,
      shopId: 'shop-001',
      shopName: 'Bismillah Ghee & Oil Traders',
      ownerName: 'Muhammad Ahmed',
      phone: '0300-1234567',
      locationLabel: 'Sector I-10/4 Market',
      sequence: 1,
      status: TaskStatus.completed,
      shopLatitude: 33.6450,
      shopLongitude: 73.0380,
    ),
    ObTaskModel(
      id: 2,
      shopId: 'shop-002',
      shopName: 'Kohsar General & Provision Store',
      ownerName: 'Hassan Raza',
      phone: '0321-9876543',
      locationLabel: 'F-10 Markaz',
      sequence: 2,
      status: TaskStatus.inVisit,
      shopLatitude: 33.6931,
      shopLongitude: 72.9875,
    ),
    ObTaskModel(
      id: 3,
      shopId: 'shop-003',
      shopName: 'Margalla Mart Express',
      ownerName: 'Ali Khan',
      phone: '0333-5551212',
      locationLabel: 'G-11 Markaz',
      sequence: 3,
      status: TaskStatus.pending,
      shopLatitude: 33.6652,
      shopLongitude: 72.9961,
    ),
    ObTaskModel(
      id: 4,
      shopId: 'shop-004',
      shopName: 'Islamabad Cash & Carry',
      ownerName: 'Usman Tariq',
      phone: '0345-1112233',
      locationLabel: 'PWD Commercial Area',
      sequence: 4,
      status: TaskStatus.skipped,
      shopLatitude: 33.5684,
      shopLongitude: 73.1360,
    ),
    ObTaskModel(
      id: 5,
      shopId: 'shop-005',
      shopName: 'Pak-Saudi Kiryana Store',
      ownerName: 'Bilal Hussain',
      phone: '0302-7788990',
      locationLabel: 'G-9/4 Commercial',
      sequence: 5,
      status: TaskStatus.pending,
      shopLatitude: 33.6805,
      shopLongitude: 73.0305,
    ),
  ];

  static ObActiveVisitModel? get obActiveVisit => const ObActiveVisitModel(
    visitId: 9001,
    taskId: 2,
    shopId: 'shop-002',
    shopName: 'Kohsar General & Provision Store',
    latitude: 33.6931,
    longitude: 72.9875,
  );

  static List<ObProductModel> get obSellableProducts => const [
    ObProductModel(
      id: 101,
      name: 'Shahtaj Cooking Oil 1L Pouch',
      unit: 'Carton',
      priceUnit: 5880, // 12 Pouches x 490 PKR
      qtyBookable: 48,
      sku: 'ST-CO-1LP',
    ),
    ObProductModel(
      id: 102,
      name: 'Shahtaj Cooking Oil 5L Bottle',
      unit: 'Carton',
      priceUnit: 9800, // 4 Bottles x 2450 PKR
      qtyBookable: 24,
      sku: 'ST-CO-5LB',
    ),
    ObProductModel(
      id: 103,
      name: 'Shahtaj Banaspati Ghee 16kg Tin',
      unit: 'Tin',
      priceUnit: 7920, // 1 bulk unit
      qtyBookable: 16,
      sku: 'ST-BG-16KT',
    ),
    ObProductModel(
      id: 104,
      name: 'Shahtaj Premium Vegetable Oil 1L Bottle',
      unit: 'Carton',
      priceUnit: 5640, // 12 Bottles x 470 PKR
      qtyBookable: 60,
      sku: 'ST-VO-1LB',
    ),
    ObProductModel(
      id: 105,
      name: 'Shahtaj Premium Banaspati 1L Pouch',
      unit: 'Carton',
      priceUnit: 5760, // 12 Pouches x 480 PKR
      qtyBookable: 30,
      sku: 'ST-PB-1LP',
    ),
  ];

  // ---------- Order Booker Visit History ----------
  static List<ObVisitSummaryModel> get obVisitHistory {
    final now = DateTime.now();
    DateTime daysAgo(int days, {int hour = 10}) =>
        DateTime(now.year, now.month, now.day - days, hour, 30);

    return [
      ObVisitSummaryModel(
        visitId: 8801,
        shopName: 'Bismillah Ghee & Oil Traders',
        ownerName: 'Muhammad Ahmed',
        checkedInAt: daysAgo(0, hour: 9),
        checkedOutAt: daysAgo(0, hour: 9).add(const Duration(minutes: 42)),
        outcome: VisitOutcome.orderPlaced,
        orderId: 5001,
        orderNumber: 'SO-5001',
        subtotal: 31360,
      ),
      ObVisitSummaryModel(
        visitId: 8795,
        shopName: 'Pak-Saudi Kiryana Store',
        ownerName: 'Bilal Hussain',
        checkedInAt: daysAgo(1, hour: 11),
        checkedOutAt: daysAgo(1, hour: 11).add(const Duration(minutes: 18)),
        outcome: VisitOutcome.endedWithoutOrder,
      ),
      ObVisitSummaryModel(
        visitId: 8788,
        shopName: 'Margalla Mart Express',
        ownerName: 'Ali Khan',
        checkedInAt: daysAgo(2, hour: 14),
        checkedOutAt: daysAgo(2, hour: 14).add(const Duration(minutes: 8)),
        outcome: VisitOutcome.skipped,
      ),
      ObVisitSummaryModel(
        visitId: 8772,
        shopName: 'Islamabad Cash & Carry',
        ownerName: 'Usman Tariq',
        checkedInAt: daysAgo(4, hour: 10),
        checkedOutAt: daysAgo(4, hour: 10).add(const Duration(minutes: 55)),
        outcome: VisitOutcome.orderPlaced,
        orderId: 4988,
        orderNumber: 'SO-4988',
        subtotal: 51240,
      ),
      ObVisitSummaryModel(
        visitId: 8760,
        shopName: 'Kohsar General & Provision Store',
        ownerName: 'Hassan Raza',
        checkedInAt: daysAgo(6, hour: 16),
        checkedOutAt: daysAgo(6, hour: 16).add(const Duration(minutes: 25)),
        outcome: VisitOutcome.orderPlaced,
        orderId: 4975,
        orderNumber: 'SO-4975',
        subtotal: 17280,
      ),
      ObVisitSummaryModel(
        visitId: 8751,
        shopName: 'Bismillah Ghee & Oil Traders',
        ownerName: 'Muhammad Ahmed',
        checkedInAt: daysAgo(8, hour: 12),
        checkedOutAt: daysAgo(8, hour: 12).add(const Duration(minutes: 30)),
        outcome: VisitOutcome.endedWithoutOrder,
      ),
      ObVisitSummaryModel(
        visitId: 8740,
        shopName: 'Rawal Foods & Catering',
        ownerName: 'Imran Shah',
        checkedInAt: daysAgo(12, hour: 9),
        checkedOutAt: daysAgo(12, hour: 9).add(const Duration(minutes: 38)),
        outcome: VisitOutcome.orderPlaced,
        orderId: 4960,
        orderNumber: 'SO-4960',
        subtotal: 45360,
      ),
      ObVisitSummaryModel(
        visitId: 8722,
        shopName: 'Saddar Wholesale Traders',
        ownerName: 'Hassan Ali',
        checkedInAt: daysAgo(20, hour: 15),
        checkedOutAt: daysAgo(20, hour: 15).add(const Duration(minutes: 22)),
        outcome: VisitOutcome.endedWithoutOrder,
      ),
    ];
  }

  static ObVisitDetailModel obVisitDetail(int visitId) {
    final summary = obVisitHistory.firstWhere(
      (visit) => visit.visitId == visitId,
      orElse: () => obVisitHistory.first,
    );

    final lines = switch (visitId) {
      8801 => const [
        ObVisitCartLineModel(
          lineId: 1,
          productId: 101,
          productName: 'Shahtaj Cooking Oil 1L Pouch',
          quantity: 4,
          priceUnit: 5880,
          unit: 'Carton',
        ),
        ObVisitCartLineModel(
          lineId: 2,
          productId: 102,
          productName: 'Shahtaj Cooking Oil 5L Bottle',
          quantity: 2,
          priceUnit: 9800,
          unit: 'Carton',
        ),
      ],
      8772 => const [
        ObVisitCartLineModel(
          lineId: 3,
          productId: 103,
          productName: 'Shahtaj Banaspati Ghee 16kg Tin',
          quantity: 5,
          priceUnit: 7920,
          unit: 'Tin',
        ),
        ObVisitCartLineModel(
          lineId: 4,
          productId: 104,
          productName: 'Shahtaj Premium Vegetable Oil 1L Bottle',
          quantity: 2,
          priceUnit: 5640,
          unit: 'Carton',
        ),
      ],
      8760 => const [
        ObVisitCartLineModel(
          lineId: 5,
          productId: 105,
          productName: 'Shahtaj Premium Banaspati 1L Pouch',
          quantity: 3,
          priceUnit: 5760,
          unit: 'Carton',
        ),
      ],
      8740 => const [
        ObVisitCartLineModel(
          lineId: 6,
          productId: 101,
          productName: 'Shahtaj Cooking Oil 1L Pouch',
          quantity: 5,
          priceUnit: 5880,
          unit: 'Carton',
        ),
        ObVisitCartLineModel(
          lineId: 7,
          productId: 103,
          productName: 'Shahtaj Banaspati Ghee 16kg Tin',
          quantity: 2,
          priceUnit: 7920,
          unit: 'Tin',
        ),
      ],
      _ => const <ObVisitCartLineModel>[],
    };

    final subtotal = lines.fold<double>(0, (sum, line) => sum + line.lineTotal);

    return ObVisitDetailModel(
      visitId: summary.visitId,
      shopId: 'shop-${summary.visitId % 100}',
      shopName: summary.shopName,
      ownerName: summary.ownerName,
      shopPhone: '+923001234567',
      locationLabel: 'I-10 Wholesale Market Route A',
      checkedInAt: summary.checkedInAt,
      checkedOutAt: summary.checkedOutAt,
      outcome: summary.outcome,
      notes: summary.outcome == VisitOutcome.endedWithoutOrder
          ? 'Shop owner asked to reorder next week.'
          : summary.outcome == VisitOutcome.skipped
          ? 'Shop was closed during visit window.'
          : null,
      lines: lines,
      subtotal: summary.subtotal ?? subtotal,
      orderId: summary.orderId,
      orderNumber: summary.orderNumber,
      latitude: 33.6450,
      longitude: 73.0380,
    );
  }

  static ObTargetsModel get obTargets =>
      const ObTargetsModel(ordersCurrent: 8, ordersTarget: 15);

  // ---------- Delivery Man Dashboard ----------
  static List<DmStockItemModel> get dmStockItems => const [
    DmStockItemModel(
      id: 'stock-001',
      name: 'Shahtaj Cooking Oil 5L',
      quantity: 45,
      unit: 'Bottles',
      isLowStock: true,
      imageAsset: AppImages.onboardingIntro,
    ),
    DmStockItemModel(
      id: 'stock-002',
      name: 'Shahtaj Banaspati Ghee 16kg',
      quantity: 120,
      unit: 'Tins',
      imageAsset: AppImages.onboardingLanguage,
    ),
    DmStockItemModel(
      id: 'stock-003',
      name: 'Shahtaj Cooking Oil 1L',
      quantity: 12,
      unit: 'Pouches',
      isLowStock: true,
      imageAsset: AppImages.onboardingRole,
    ),
  ];

  static int get dmVanStockCount => 24;

  // ---------- Recovery Man Dashboard ----------
  static RmTargetsModel get rmTargets =>
      const RmTargetsModel(recoveryCurrent: 145000, recoveryTarget: 250000);

  static List<ObOrderSummaryModel> get obRecentOrders => const [
    ObOrderSummaryModel(
      id: 'ord-5521',
      orderNumber: '#ORD-5521',
      shopName: 'Bismillah Ghee & Oil Traders',
      amount: 31360,
      status: OrderStatus.delivered,
    ),
    ObOrderSummaryModel(
      id: 'ord-5518',
      orderNumber: '#ORD-5518',
      shopName: 'Kohsar General & Provision Store',
      amount: 17280,
      status: OrderStatus.submitted,
    ),
    ObOrderSummaryModel(
      id: 'ord-5515',
      orderNumber: '#ORD-5515',
      shopName: 'Margalla Mart Express',
      amount: 23500,
      status: OrderStatus.draft,
    ),
  ];

  // ---------- Order Booker Shops ----------
  static List<ObZoneOption> get obZones => const [
    ObZoneOption(id: 1, name: 'Islamabad Capital Zone'),
    ObZoneOption(id: 2, name: 'Rawalpindi Zone'),
    ObZoneOption(id: 3, name: 'Saddar Wholesale Zone'),
  ];

  static List<ObRouteOption> get obRoutes => const [
    ObRouteOption(id: 1, zoneId: 1, name: 'I-10 Wholesale Market Route A'),
    ObRouteOption(id: 2, zoneId: 1, name: 'F-10 / G-11 Retail Route B'),
    ObRouteOption(id: 3, zoneId: 2, name: 'PWD Residential Route B'),
    ObRouteOption(id: 4, zoneId: 3, name: 'Raja Bazar Bulk Route A'),
  ];

  static List<ObShopModel> get obShops => const [
    ObShopModel(
      id: 'shop-001',
      name: 'Bismillah Ghee & Oil Traders',
      ownerName: 'Muhammad Ahmed',
      phone: '0300-1234567',
      locationLabel: 'Sector I-10/4 Market',
      zoneName: 'Islamabad Capital Zone',
      routeName: 'I-10 Wholesale Market Route A',
      creditLimit: 150000,
      legacyBalance: 42500,
      latitude: 33.6450,
      longitude: 73.0380,
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
      name: 'Kohsar General & Provision Store',
      ownerName: 'Hassan Raza',
      phone: '0321-9876543',
      locationLabel: 'F-10 Markaz',
      zoneName: 'Islamabad Capital Zone',
      routeName: 'F-10 / G-11 Retail Route B',
      creditLimit: 75000,
      legacyBalance: 14200,
      latitude: 33.6931,
      longitude: 72.9875,
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
      name: 'Margalla Mart Express',
      ownerName: 'Ali Khan',
      phone: '0333-5551212',
      locationLabel: 'G-11 Markaz',
      zoneName: 'Islamabad Capital Zone',
      routeName: 'F-10 / G-11 Retail Route B',
      creditLimit: 100000,
      legacyBalance: 0,
      latitude: 33.6652,
      longitude: 72.9961,
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
      name: 'Islamabad Cash & Carry',
      ownerName: 'Usman Tariq',
      phone: '0345-1112233',
      locationLabel: 'PWD Commercial Area',
      zoneName: 'Rawalpindi Zone',
      routeName: 'PWD Residential Route B',
      creditLimit: 200000,
      legacyBalance: 88900,
      latitude: 33.5684,
      longitude: 73.1360,
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
      name: 'Pak-Saudi Kiryana Store',
      ownerName: 'Bilal Hussain',
      phone: '0302-7788990',
      locationLabel: 'G-9/4 Commercial',
      zoneName: 'Islamabad Capital Zone',
      routeName: 'I-10 Wholesale Market Route A',
      creditLimit: 60000,
      legacyBalance: 16100,
      latitude: 33.6805,
      longitude: 73.0305,
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
