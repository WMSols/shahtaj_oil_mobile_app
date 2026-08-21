import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_collection_targets_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/dashboard/dm_collection_dashboard_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/delivery_man_shell_controller.dart';

class DmDashboardController extends GetxController {
  DmDashboardController(
    this._pickupService,
    this._deliveryService,
    this._collectionService,
  );

  final DmPickupService _pickupService;
  final DmDeliveryService _deliveryService;
  final DmCollectionDashboardService _collectionService;
  final SessionService _session = Get.find<SessionService>();

  final RxBool isLoading = true.obs;
  final RxInt pendingCount = 0.obs;
  final RxInt inTransitCount = 0.obs;
  final RxInt deliveredCount = 0.obs;
  final RxBool pickupConfirmed = false.obs;

  final RxList<DmStockItemModel> stockItems = <DmStockItemModel>[].obs;

  final RxDouble collectedToday = 0.0.obs;
  final RxDouble stillDue = 0.0.obs;
  final RxDouble cashInBag = 0.0.obs;
  final Rx<DmCollectionTargetsModel> targets =
      const DmCollectionTargetsModel().obs;
  final RxList<DmCollectionSummaryModel> recentCollections =
      <DmCollectionSummaryModel>[].obs;

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
      await Future.wait([_loadDeliveries(), _loadCollections()]);
    } finally {
      isLoading.value = false;
    }
  }

  /// Silent refresh used after recording a collection or completing a handover.
  Future<void> refreshCollections() => _loadCollections();

  Future<void> _loadDeliveries() async {
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
        deliveredByName[key] = (deliveredByName[key] ?? 0) + line.deliveredQty;
      }
    }

    stockItems.assignAll(
      pickup.items.map((item) {
        final delivered = deliveredByName[item.name.trim().toLowerCase()] ?? 0;
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
  }

  Future<void> _loadCollections() async {
    final dashboard = await _collectionService.fetchDashboard();
    collectedToday.value = dashboard.collectedToday;
    stillDue.value = dashboard.stillDue;
    cashInBag.value = dashboard.cashInBag;
    targets.value = dashboard.targets;
    recentCollections.assignAll(dashboard.recentCollections);
  }

  void goToPickup() => _selectLeaf('dm_pickup');

  void goToOrders() => _selectLeaf('dm_orders');

  void goToTodayShops() => _selectLeaf('dm_today_shops');

  void goToCollectionHistory() => _selectLeaf('dm_collection_history');

  void goToHandover() => _selectLeaf('dm_handover');

  void openCollection(DmCollectionSummaryModel collection) {
    Get.toNamed(
      AppRoutes.dmCollectionDetail.replaceFirst(':id', collection.id),
      arguments: {'collectionId': collection.id},
    );
  }

  void _selectLeaf(String id) {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf(id);
  }
}
