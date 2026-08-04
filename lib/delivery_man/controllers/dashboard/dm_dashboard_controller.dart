import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/shell/delivery_man_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';

class DmDashboardController extends GetxController {
  DmDashboardController(this._pickupService, this._deliveryService);

  final DmPickupService _pickupService;
  final DmDeliveryService _deliveryService;
  final SessionService _session = Get.find<SessionService>();

  final RxBool isLoading = true.obs;
  final RxInt pendingCount = 0.obs;
  final RxInt inTransitCount = 0.obs;
  final RxInt deliveredCount = 0.obs;
  final RxBool pickupConfirmed = false.obs;

  final RxList<DmStockItemModel> stockItems = <DmStockItemModel>[].obs;

  int get loadedStockCount =>
      stockItems.fold<int>(0, (sum, item) => sum + item.quantity);

  int get onHandStockCount =>
      stockItems.fold<int>(0, (sum, item) => sum + item.onHand);

  String get greeting => AppFormatter.timeOfDayGreeting();
  String get userName =>
      _session.user.value?.displayName('Delivery Man') ?? 'Delivery Man';

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final pickup = await _pickupService.fetchTodayPickup();
      pickupConfirmed.value = pickup.isAcknowledged;

      final orders = await _deliveryService.fetchOrders();
      pendingCount.value = orders
          .where((o) => o.status == DeliveryStatus.pending)
          .length;
      inTransitCount.value = orders
          .where(
            (o) =>
                o.status == DeliveryStatus.inTransit ||
                o.status == DeliveryStatus.pickedUp,
          )
          .length;
      deliveredCount.value = orders
          .where((o) => o.status == DeliveryStatus.delivered)
          .length;

      final deliveredByName = <String, double>{};
      for (final order in orders) {
        for (final line in order.lines) {
          if (line.deliveredQty <= 0) continue;
          final key = line.productName.trim().toLowerCase();
          deliveredByName[key] =
              (deliveredByName[key] ?? 0) + line.deliveredQty;
        }
      }

      stockItems.assignAll(
        pickup.items.map((item) {
          final delivered =
              deliveredByName[item.name.trim().toLowerCase()] ?? 0;
          final onHand = (item.quantity - delivered.round()).clamp(
            0,
            item.quantity,
          );
          return item.copyWith(
            onHandQuantity: onHand,
            isLowStock: onHand <= (item.quantity * 0.25).ceil(),
          );
        }),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToPickup() => _selectLeaf('dm_pickup');

  void goToOrders() => _selectLeaf('dm_orders');

  void _selectLeaf(String id) {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf(id);
  }
}
