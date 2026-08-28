import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van_stock/dm_van_stock_document_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van_stock/dm_van_stock_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';

/// Editable whole-list van load / unload. Zero load / empty van completes
/// remaining open deliveries.
class DmVanStockService extends GetxService {
  DmVanStockService({
    DmPickupService? pickup,
    DmDeliveryService? delivery,
    OfflineCacheService? cache,
    ConnectivityService? connectivity,
  }) : _pickup = pickup ?? Get.find<DmPickupService>(),
       _delivery = delivery ?? Get.find<DmDeliveryService>(),
       _cache = cache ?? Get.find<OfflineCacheService>(),
       _connectivity = connectivity ?? Get.find<ConnectivityService>();

  final DmPickupService _pickup;
  final DmDeliveryService _delivery;
  final OfflineCacheService _cache;
  final ConnectivityService _connectivity;

  static const _role = 'deliveryMan';

  DateTime? _unloadedAt;
  String _notes = '';
  List<DmVanStockDocumentModel> _history = const [];
  bool _metaHydrated = false;

  @override
  void onInit() {
    super.onInit();
    _cache.registerSyncHandler(_role, 'van_load_all', (_) async {});
    _cache.registerSyncHandler(_role, 'van_unload_all', (_) async {});
  }

  Future<void> _ensureMetaHydrated() async {
    if (_metaHydrated) return;
    final cached = await _cache.readMap(OfflineCacheKeys.dmVanStock);
    if (cached != null) {
      _unloadedAt = DateTime.tryParse('${cached['unloaded_at'] ?? ''}');
      _notes = cached['notes']?.toString() ?? '';
      final rawHistory = cached['history'];
      if (rawHistory is List) {
        _history = rawHistory
            .whereType<Map>()
            .map(
              (e) => DmVanStockDocumentModel.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList(growable: false);
      }
    }
    _metaHydrated = true;
  }

  Future<void> _persistMeta() async {
    await _cache.saveMap(OfflineCacheKeys.dmVanStock, {
      'unloaded_at': _unloadedAt?.toIso8601String(),
      'notes': _notes,
      'history': _history.map((e) => e.toJson()).toList(),
    });
  }

  Future<void> _enqueue(String action, Map<String, dynamic> payload) async {
    await _cache.enqueueSync(role: _role, action: action, payload: payload);
    if (_connectivity.isOnline.value) {
      await _cache.flushSyncQueue();
    }
  }

  Future<DmVanStockModel> fetchVanStock() async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    await _ensureMetaHydrated();

    final pickup = await _pickup.fetchTodayPickup();
    final orders = await _delivery.fetchOrders();

    final deliveredByName = <String, double>{};
    for (final order in orders) {
      for (final line in order.lines) {
        if (line.deliveredQty <= 0) continue;
        final key = line.productName.trim().toLowerCase();
        deliveredByName[key] = (deliveredByName[key] ?? 0) + line.deliveredQty;
      }
    }

    final unloaded = _unloadedAt != null;
    final items = pickup.items
        .map((item) {
          final delivered =
              deliveredByName[item.name.trim().toLowerCase()] ?? 0;
          final remaining = pickup.isAcknowledged
              ? (item.quantity - delivered.round()).clamp(0, item.quantity)
              : 0;
          final onHand = unloaded ? 0 : remaining;
          return item.copyWith(
            onHandQuantity: onHand,
            isLowStock: onHand > 0 && onHand <= (item.quantity * 0.25).ceil(),
          );
        })
        .toList(growable: false);

    return DmVanStockModel(
      id: pickup.id,
      warehouseName: pickup.warehouseName,
      vehicleCode: pickup.vehicleCode,
      shiftDate: pickup.shiftDate,
      items: items,
      loadedAt: pickup.acknowledgedAt,
      unloadedAt: _unloadedAt,
      notes: _notes,
      history: _history,
    );
  }

  /// Confirm load with per-SKU edited quantities (0 allowed).
  Future<DmVanStockModel> confirmLoad({
    required Map<String, int> quantitiesByItemId,
    String notes = '',
  }) async {
    final pickup = await _pickup.fetchTodayPickup();
    if (pickup.isAcknowledged) {
      return fetchVanStock();
    }

    final loadedItems = pickup.items
        .map((item) {
          final qty = quantitiesByItemId[item.id] ?? 0;
          return item.copyWith(
            quantity: qty,
            expectedQuantity: item.expected,
            onHandQuantity: qty,
            isLowStock: qty > 0 && qty <= 15,
          );
        })
        .toList(growable: false);

    await _pickup.confirmPickup(loadedItems: loadedItems);
    _notes = notes.trim();
    _unloadedAt = null;

    final doc = DmVanStockDocumentModel(
      id: 'van-load-${DateTime.now().millisecondsSinceEpoch}',
      kind: DmVanStockDocumentKind.load,
      at: DateTime.now(),
      items: loadedItems,
      notes: _notes,
    );
    _history = [doc, ..._history];
    await _persistMeta();

    await _enqueue('van_load_all', {
      'pickup_id': pickup.id,
      'notes': _notes,
      'items': loadedItems.map((e) => e.toJson()).toList(),
    });

    final loadedByProduct = <String, int>{
      for (final item in loadedItems)
        item.name.trim().toLowerCase(): item.quantity,
    };
    final allZero = loadedItems.every((item) => item.quantity <= 0);
    await _delivery.completeOpenOrdersForZeroStock(
      loadedByProduct: loadedByProduct,
      reason: allZero
          ? 'Auto-completed: no stock loaded on van'
          : 'Auto-completed: product not loaded (qty 0)',
      forceAll: allZero,
    );

    return fetchVanStock();
  }

  /// Confirm unload with per-SKU edited return quantities (0 allowed).
  Future<DmVanStockModel> confirmUnload({
    required Map<String, int> quantitiesByItemId,
    String notes = '',
  }) async {
    final current = await fetchVanStock();
    if (!current.canUnload) return current;

    await Future<void>.delayed(const Duration(milliseconds: 200));
    _unloadedAt = DateTime.now();
    if (notes.trim().isNotEmpty) _notes = notes.trim();

    final unloadedItems = current.items
        .map((item) {
          final qty = (quantitiesByItemId[item.id] ?? 0).clamp(0, item.onHand);
          return item.copyWith(
            quantity: qty,
            onHandQuantity: 0,
            isLowStock: false,
          );
        })
        .toList(growable: false);

    final doc = DmVanStockDocumentModel(
      id: 'van-unload-${DateTime.now().millisecondsSinceEpoch}',
      kind: DmVanStockDocumentKind.unload,
      at: _unloadedAt!,
      items: unloadedItems,
      notes: _notes,
    );
    _history = [doc, ..._history];
    await _persistMeta();

    await _enqueue('van_unload_all', {
      'van_id': current.id,
      'notes': _notes,
      'unloaded_at': _unloadedAt!.toIso8601String(),
      'items': unloadedItems.map((e) => e.toJson()).toList(),
    });

    // Day closed: any remaining open stops complete with delivered 0.
    await _delivery.completeOpenOrdersForZeroStock(
      loadedByProduct: const {},
      reason: 'Auto-completed: van unloaded / stock cleared',
      forceAll: true,
    );

    return fetchVanStock();
  }

  bool get isUnloaded => _unloadedAt != null;
}
