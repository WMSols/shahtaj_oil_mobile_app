import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_order_line_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/pickup/dm_pickup_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/return/dm_return_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_timeline_event_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/dashboard/rm_targets_model.dart';

/// Mock payloads still used by DM/RM stubs.
/// Order Booker uses live APIs + [OfflineCacheService].
class AppMockData {
  AppMockData._();

  static List<DmStockItemModel> get dmStockItems => const [
    DmStockItemModel(
      id: 'stock-001',
      name: 'Shahtaj Cooking Oil 5L',
      quantity: 45,
      expectedQuantity: 45,
      unit: 'Bottles',
      isLowStock: true,
      imageAsset: AppImages.onboardingIntro,
    ),
    DmStockItemModel(
      id: 'stock-002',
      name: 'Shahtaj Banaspati Ghee 16kg',
      quantity: 120,
      expectedQuantity: 120,
      unit: 'Tins',
      imageAsset: AppImages.onboardingLanguage,
    ),
    DmStockItemModel(
      id: 'stock-003',
      name: 'Shahtaj Cooking Oil 1L',
      quantity: 12,
      expectedQuantity: 12,
      unit: 'Pouches',
      isLowStock: true,
      imageAsset: AppImages.onboardingRole,
    ),
  ];

  static int get dmVanStockCount =>
      dmStockItems.fold<int>(0, (sum, item) => sum + item.quantity);

  static DmPickupModel get dmPickupSession => DmPickupModel(
    id: 'pickup-shift-20260716',
    warehouseName: 'Shahtaj Main Warehouse',
    vehicleCode: 'DM-ISB-12',
    shiftDate: DateTime(2026, 7, 16, 8),
    items: dmStockItems,
  );

  static List<DmOrderLineModel> _lines({
    required List<(String, String, double, double, double, double)> rows,
  }) {
    return [
      for (var i = 0; i < rows.length; i++)
        DmOrderLineModel(
          id: 'line-${i + 1}',
          productName: rows[i].$1,
          unit: rows[i].$2,
          orderedQty: rows[i].$3,
          loadedQty: rows[i].$4,
          deliveredQty: rows[i].$5,
          unitPrice: rows[i].$6,
        ),
    ];
  }

  static List<DmDeliveryOrderModel> get dmOrders {
    final assignedAt = DateTime(2026, 7, 16, 8, 30);
    return [
      DmDeliveryOrderModel(
        id: 'dm-order-001',
        deliveryNumber: 'DL-001001',
        orderNumber: 'SO-001245',
        shopName: 'Al Madina Store',
        shopAddress: 'F-6 Markaz, Islamabad',
        status: DeliveryStatus.pending,
        scheduledAt: DateTime(2026, 7, 16, 10),
        lines: _lines(
          rows: const [
            ('Shahtaj Cooking Oil 5L', 'Bottles', 10, 0, 0, 2200),
            ('Shahtaj Cooking Oil 1L', 'Pouches', 20, 0, 0, 480),
          ],
        ),
        timeline: [
          DmTimelineEventModel(
            id: 'tl-001-a',
            title: 'Order assigned',
            at: assignedAt,
          ),
        ],
      ),
      DmDeliveryOrderModel(
        id: 'dm-order-002',
        deliveryNumber: 'DL-001002',
        orderNumber: 'SO-001246',
        shopName: 'Karim Traders',
        shopAddress: 'Blue Area, Islamabad',
        status: DeliveryStatus.inTransit,
        scheduledAt: DateTime(2026, 7, 16, 11),
        lines: _lines(
          rows: const [('Shahtaj Banaspati Ghee 16kg', 'Tins', 2, 2, 0, 6050)],
        ),
        timeline: [
          DmTimelineEventModel(
            id: 'tl-002-a',
            title: 'Order assigned',
            at: assignedAt,
          ),
          DmTimelineEventModel(
            id: 'tl-002-b',
            title: 'Stock picked up',
            at: DateTime(2026, 7, 16, 9, 10),
          ),
          DmTimelineEventModel(
            id: 'tl-002-c',
            title: 'Out for delivery',
            at: DateTime(2026, 7, 16, 10, 5),
          ),
        ],
      ),
      DmDeliveryOrderModel(
        id: 'dm-order-003',
        deliveryNumber: 'DL-001003',
        orderNumber: 'SO-001247',
        shopName: 'City Mart',
        shopAddress: 'G-9, Islamabad',
        status: DeliveryStatus.delivered,
        scheduledAt: DateTime(2026, 7, 16, 9),
        receiverName: 'Ahmed Khan',
        deliveredAt: DateTime(2026, 7, 16, 9, 45),
        lines: _lines(
          rows: const [
            ('Shahtaj Cooking Oil 5L', 'Bottles', 8, 8, 8, 2200),
            ('Shahtaj Cooking Oil 1L', 'Pouches', 15, 15, 15, 480),
            ('Shahtaj Banaspati Ghee 16kg', 'Tins', 3, 3, 3, 6050),
          ],
        ),
        timeline: [
          DmTimelineEventModel(
            id: 'tl-003-a',
            title: 'Order assigned',
            at: assignedAt,
          ),
          DmTimelineEventModel(
            id: 'tl-003-b',
            title: 'Stock picked up',
            at: DateTime(2026, 7, 16, 8, 50),
          ),
          DmTimelineEventModel(
            id: 'tl-003-c',
            title: 'Out for delivery',
            at: DateTime(2026, 7, 16, 9, 10),
          ),
          DmTimelineEventModel(
            id: 'tl-003-d',
            title: 'Delivered',
            at: DateTime(2026, 7, 16, 9, 45),
            note: 'Received by Ahmed Khan',
          ),
        ],
      ),
      DmDeliveryOrderModel(
        id: 'dm-order-004',
        deliveryNumber: 'DL-001004',
        orderNumber: 'SO-001248',
        shopName: 'Rana Super Store',
        shopAddress: 'I-8 Markaz, Islamabad',
        status: DeliveryStatus.returned,
        scheduledAt: DateTime(2026, 7, 16, 12),
        lines: [
          const DmOrderLineModel(
            id: 'line-1',
            productName: 'Shahtaj Cooking Oil 5L',
            unit: 'Bottles',
            orderedQty: 6,
            loadedQty: 6,
            deliveredQty: 2,
            rejectedQty: 3,
            unitPrice: 2200,
          ),
          const DmOrderLineModel(
            id: 'line-2',
            productName: 'Shahtaj Cooking Oil 1L',
            unit: 'Pouches',
            orderedQty: 10,
            loadedQty: 10,
            deliveredQty: 0,
            rejectedQty: 10,
            unitPrice: 480,
          ),
        ],
        timeline: [
          DmTimelineEventModel(
            id: 'tl-004-a',
            title: 'Order assigned',
            at: assignedAt,
          ),
          DmTimelineEventModel(
            id: 'tl-004-b',
            title: 'Stock picked up',
            at: DateTime(2026, 7, 16, 9, 20),
          ),
          DmTimelineEventModel(
            id: 'tl-004-c',
            title: 'Out for delivery',
            at: DateTime(2026, 7, 16, 11, 0),
          ),
          DmTimelineEventModel(
            id: 'tl-004-d',
            title: 'Returned / partial',
            at: DateTime(2026, 7, 16, 12, 30),
            note: 'Shop rejected part of the load',
          ),
        ],
      ),
    ];
  }

  static DmReturnModel get dmReturnTemplate =>
      const DmReturnModel(id: '', deliveryId: 'shift-20260716', leftover: []);

  static RmTargetsModel get rmTargets =>
      const RmTargetsModel(recoveryCurrent: 145000, recoveryTarget: 250000);
}
