import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_shop_due_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_dashboard_activity_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_targets_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/handover/dm_handover_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/dashboard/dm_collection_dashboard_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van_stock/dm_van_stock_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';

class DmDashboardController extends GetxController {
  DmDashboardController(
    this._pickupService,
    this._deliveryService,
    this._collectionService,
    this._vanStockService,
  );

  final DmPickupService _pickupService;
  final DmDeliveryService _deliveryService;
  final DmCollectionDashboardService _collectionService;
  final DmVanStockService _vanStockService;
  final SessionService _session = Get.find<SessionService>();

  static const recentPreviewLimit = 3;

  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final RxnString error = RxnString();

  final RxInt pendingCount = 0.obs;
  final RxInt inTransitCount = 0.obs;
  final RxInt deliveredCount = 0.obs;
  final RxBool pickupConfirmed = false.obs;
  final RxBool vanUnloaded = false.obs;
  final RxInt vanOnHandTotal = 0.obs;
  final Rxn<DmDeliveryOrderModel> nextOrder = Rxn<DmDeliveryOrderModel>();

  final RxList<DmStockItemModel> stockItems = <DmStockItemModel>[].obs;

  final RxDouble collectedToday = 0.0.obs;
  final RxDouble stillDue = 0.0.obs;
  final RxDouble cashInBag = 0.0.obs;
  final RxInt shopsDueCount = 0.obs;
  final RxInt bagReceiptCount = 0.obs;
  final Rxn<DmShopDueModel> nextDueShop = Rxn<DmShopDueModel>();
  final Rx<DmTargetsModel> targets = const DmTargetsModel().obs;
  final RxList<DmDashboardActivityItem> recentActivity =
      <DmDashboardActivityItem>[].obs;

  bool get hasContent =>
      pendingCount.value + inTransitCount.value + deliveredCount.value > 0 ||
      stockItems.isNotEmpty ||
      recentActivity.isNotEmpty ||
      collectedToday.value > 0 ||
      stillDue.value > 0;

  List<DmDashboardActivityItem> get previewRecentActivity =>
      recentActivity.take(recentPreviewLimit).toList(growable: false);

  bool get showNextDeliveryStop =>
      nextOrder.value != null && nextAction?.kind != DmNextActionKind.deliver;

  bool get showNextCollectionStop =>
      nextDueShop.value != null && nextAction?.kind != DmNextActionKind.collect;

  String get greeting => AppFormatter.timeOfDayGreeting();
  String get userName =>
      _session.user.value?.displayName('Delivery Man') ?? 'Delivery Man';

  DmNextActionModel? get nextAction {
    if (!pickupConfirmed.value) {
      return DmNextActionModel(
        kind: DmNextActionKind.pickup,
        message: AppTexts.dmNextPickupSubtitle,
        buttonLabel: AppTexts.dmVanLoadAll,
      );
    }

    final order = nextOrder.value;
    if (order != null) {
      return DmNextActionModel(
        kind: DmNextActionKind.deliver,
        message: order.shopName,
        buttonLabel: AppTexts.dmContinueDeliveries,
      );
    }

    if (!vanUnloaded.value) {
      return DmNextActionModel(
        kind: DmNextActionKind.unload,
        message: AppTexts.dmNextUnloadSubtitle,
        buttonLabel: vanOnHandTotal.value <= 0
            ? AppTexts.dmVanCloseEmpty
            : AppTexts.dmVanUnloadAll,
      );
    }

    if (cashInBag.value > 0) {
      return DmNextActionModel(
        kind: DmNextActionKind.handover,
        message: AppTexts.dmHandoverNudgeSubtitle(
          AppFormatter.compactCurrency(cashInBag.value),
          '${bagReceiptCount.value}',
        ),
        buttonLabel: AppTexts.dmConfirmHandover,
      );
    }

    if (shopsDueCount.value > 0) {
      final shop = nextDueShop.value;
      return DmNextActionModel(
        kind: DmNextActionKind.collect,
        message: shop?.name ?? AppTexts.dmShopsDueCount(shopsDueCount.value),
        buttonLabel: AppTexts.dmTodayShopsTitle,
      );
    }

    return null;
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final showFullLoader = !hasContent;
    if (showFullLoader) {
      isLoading.value = true;
    } else {
      isRefreshing.value = true;
    }

    try {
      final results = await Future.wait([
        _loadDeliveries(),
        _loadCollections(),
      ]);
      final delivery = results[0] as _DeliveryDashboardSlice;
      final collection = results[1] as _CollectionDashboardSlice;

      pickupConfirmed.value = delivery.pickupConfirmed;
      vanUnloaded.value = delivery.vanUnloaded;
      vanOnHandTotal.value = delivery.vanOnHandTotal;
      pendingCount.value = delivery.pendingCount;
      inTransitCount.value = delivery.inTransitCount;
      deliveredCount.value = delivery.deliveredCount;
      nextOrder.value = delivery.nextOrder;
      stockItems.assignAll(delivery.stockItems);

      collectedToday.value = collection.collectedToday;
      stillDue.value = collection.stillDue;
      cashInBag.value = collection.cashInBag;
      shopsDueCount.value = collection.shopsDueCount;
      bagReceiptCount.value = collection.bagReceiptCount;
      nextDueShop.value = collection.highestDueShop;

      final mockTargets = AppMockData.dmTargets;
      targets.value = mockTargets.copyWith(
        deliveryCurrent: delivery.deliveredCount,
        deliveryValueCurrent: delivery.deliveredValue,
        recoveryCurrent: collection.recoveryCurrent,
        recoveryTarget: collection.recoveryTarget,
      );

      recentActivity.assignAll(
        _mergeActivity(
          deliveredOrders: delivery.deliveredOrders,
          collections: collection.recentCollections,
          handovers: collection.recentHandovers,
        ),
      );
      error.value = null;
    } catch (_) {
      if (!hasContent) {
        error.value = AppTexts.emptyLoadFailedSubtitle;
      }
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> refreshCollections() => load();

  Future<_DeliveryDashboardSlice> _loadDeliveries() async {
    final pickup = await _pickupService.fetchTodayPickup();
    final orders = await _deliveryService.fetchOrders();
    final van = await _vanStockService.fetchVanStock();

    final pending = orders
        .where((o) => o.status == DeliveryStatus.pending)
        .length;
    final inTransit = orders
        .where(
          (o) =>
              o.status == DeliveryStatus.inTransit ||
              o.status == DeliveryStatus.pickedUp,
        )
        .length;
    final completedOrders = orders
        .where(
          (o) =>
              o.status == DeliveryStatus.delivered ||
              o.status == DeliveryStatus.returned,
        )
        .toList(growable: false);
    final deliveredValue = completedOrders.fold<double>(
      0,
      (sum, order) => sum + order.resolvedTotal,
    );

    final queue = orders
        .where(
          (o) =>
              o.status == DeliveryStatus.pending ||
              o.status == DeliveryStatus.inTransit ||
              o.status == DeliveryStatus.pickedUp,
        )
        .toList();
    queue.sort((a, b) {
      final rank = _deliveryQueueRank(
        a.status,
      ).compareTo(_deliveryQueueRank(b.status));
      if (rank != 0) return rank;
      final aAt = a.scheduledAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bAt = b.scheduledAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return aAt.compareTo(bAt);
    });

    final stock = van.items.toList()
      ..sort((a, b) {
        if (a.isLowStock == b.isLowStock) {
          return a.name.compareTo(b.name);
        }
        return a.isLowStock ? -1 : 1;
      });

    return _DeliveryDashboardSlice(
      pickupConfirmed: pickup.isAcknowledged,
      vanUnloaded: van.isUnloaded,
      vanOnHandTotal: van.totalOnHand,
      pendingCount: pending,
      inTransitCount: inTransit,
      deliveredCount: completedOrders.length,
      deliveredValue: deliveredValue,
      nextOrder: queue.isEmpty ? null : queue.first,
      deliveredOrders: completedOrders,
      stockItems: stock,
    );
  }

  Future<_CollectionDashboardSlice> _loadCollections() async {
    final dashboard = await _collectionService.fetchDashboard();
    return _CollectionDashboardSlice(
      collectedToday: dashboard.collectedToday,
      stillDue: dashboard.stillDue,
      cashInBag: dashboard.cashInBag,
      shopsDueCount: dashboard.shopsDueCount,
      bagReceiptCount: dashboard.bagReceiptCount,
      highestDueShop: dashboard.highestDueShop,
      recentCollections: dashboard.recentCollections,
      recentHandovers: dashboard.recentHandovers,
      recoveryCurrent: dashboard.targets.recoveryCurrent,
      recoveryTarget: dashboard.targets.recoveryTarget,
    );
  }

  List<DmDashboardActivityItem> _mergeActivity({
    required List<DmDeliveryOrderModel> deliveredOrders,
    required List<DmCollectionSummaryModel> collections,
    required List<DmHandoverSummaryModel> handovers,
  }) {
    final items = <DmDashboardActivityItem>[
      for (final order in deliveredOrders)
        DmDashboardActivityItem(
          kind: DmDashboardActivityKind.delivery,
          id: order.id,
          title: order.shopName,
          at: order.deliveredAt ?? order.scheduledAt ?? DateTime.now(),
          amount: order.resolvedTotal,
        ),
      for (final collection in collections)
        DmDashboardActivityItem(
          kind: DmDashboardActivityKind.collection,
          id: collection.id,
          title: collection.shopName,
          at: collection.collectedAt,
          amount: collection.amount,
        ),
      for (final handover in handovers)
        DmDashboardActivityItem(
          kind: DmDashboardActivityKind.handover,
          id: handover.id,
          title: handover.reference,
          at: handover.handedAt,
          amount: handover.total,
        ),
    ]..sort((a, b) => b.at.compareTo(a.at));
    return items;
  }

  int _deliveryQueueRank(DeliveryStatus status) => switch (status) {
    DeliveryStatus.inTransit || DeliveryStatus.pickedUp => 0,
    DeliveryStatus.pending => 1,
    _ => 2,
  };

  void runNextAction() {
    switch (nextAction?.kind) {
      case DmNextActionKind.pickup:
      case DmNextActionKind.unload:
        goToVanStock();
      case DmNextActionKind.deliver:
        openNextOrder();
      case DmNextActionKind.collect:
        openNextDueShop();
      case DmNextActionKind.handover:
        goToHandoverConfirm();
      case null:
        break;
    }
  }

  void goToPickup() => _selectLeaf('dm_pickup');

  void goToVanStock() => _selectLeaf('dm_van_stock');

  void goToOrders() => _selectLeaf('dm_orders');

  void goToDeliver() => _selectLeaf('dm_deliver');

  void goToDeliveriesList() => _selectLeaf('dm_deliveries_list');

  void goToTodayShops() => _selectLeaf('dm_today_shops');

  void goToCollectionHistory() => _selectLeaf('dm_collection_history');

  void goToHandover() => _selectLeaf('dm_handover');

  void goToHandoverConfirm() => Get.toNamed(AppRoutes.dmHandoverConfirm);

  void openNextOrder() {
    final order = nextOrder.value;
    if (order == null) {
      goToDeliver();
      return;
    }
    Get.toNamed(AppRoutes.dmOrderDetail.replaceFirst(':id', order.id));
  }

  void openNextDueShop() {
    final shop = nextDueShop.value;
    if (shop == null) {
      goToTodayShops();
      return;
    }
    Get.toNamed(
      AppRoutes.dmShopOutstanding.replaceFirst(':id', shop.id),
      arguments: {'shopId': shop.id},
    );
  }

  void openActivity(DmDashboardActivityItem item) {
    switch (item.kind) {
      case DmDashboardActivityKind.delivery:
        Get.toNamed(AppRoutes.dmDeliveryDetail.replaceFirst(':id', item.id));
      case DmDashboardActivityKind.collection:
        Get.toNamed(
          AppRoutes.dmCollectionDetail.replaceFirst(':id', item.id),
          arguments: {'collectionId': item.id},
        );
      case DmDashboardActivityKind.handover:
        Get.toNamed(
          AppRoutes.dmHandoverDetail.replaceFirst(':id', item.id),
          arguments: {'handoverId': item.id},
        );
    }
  }

  void _selectLeaf(String id) {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf(id);
  }
}

class _DeliveryDashboardSlice {
  const _DeliveryDashboardSlice({
    required this.pickupConfirmed,
    required this.vanUnloaded,
    required this.vanOnHandTotal,
    required this.pendingCount,
    required this.inTransitCount,
    required this.deliveredCount,
    required this.deliveredValue,
    required this.nextOrder,
    required this.deliveredOrders,
    required this.stockItems,
  });

  final bool pickupConfirmed;
  final bool vanUnloaded;
  final int vanOnHandTotal;
  final int pendingCount;
  final int inTransitCount;
  final int deliveredCount;
  final double deliveredValue;
  final DmDeliveryOrderModel? nextOrder;
  final List<DmDeliveryOrderModel> deliveredOrders;
  final List<DmStockItemModel> stockItems;
}

class _CollectionDashboardSlice {
  const _CollectionDashboardSlice({
    required this.collectedToday,
    required this.stillDue,
    required this.cashInBag,
    required this.shopsDueCount,
    required this.bagReceiptCount,
    required this.highestDueShop,
    required this.recentCollections,
    required this.recentHandovers,
    required this.recoveryCurrent,
    required this.recoveryTarget,
  });

  final double collectedToday;
  final double stillDue;
  final double cashInBag;
  final int shopsDueCount;
  final int bagReceiptCount;
  final DmShopDueModel? highestDueShop;
  final List<DmCollectionSummaryModel> recentCollections;
  final List<DmHandoverSummaryModel> recentHandovers;
  final double recoveryCurrent;
  final double recoveryTarget;
}
