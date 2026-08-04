import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_order_line_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_timeline_event_model.dart';

class DmDeliveryService extends GetxService {
  DmDeliveryService({
    OfflineCacheService? cache,
    ConnectivityService? connectivity,
  }) : _cache = cache ?? Get.find<OfflineCacheService>(),
       _connectivity = connectivity ?? Get.find<ConnectivityService>();

  final OfflineCacheService _cache;
  final ConnectivityService _connectivity;
  final RxList<DmDeliveryOrderModel> _orders = <DmDeliveryOrderModel>[].obs;
  bool _hydrated = false;

  static const _role = 'deliveryMan';

  @override
  void onInit() {
    super.onInit();
    // Live API calls land here when delivery endpoints exist.
    _cache.registerSyncHandler(_role, 'mark_picked_up', (_) async {});
    _cache.registerSyncHandler(_role, 'start_delivery', (_) async {});
    _cache.registerSyncHandler(_role, 'submit_delivery', (_) async {});
  }

  Future<void> _ensureHydrated() async {
    if (_hydrated) return;
    final cached = await _cache.readList(OfflineCacheKeys.dmOrders);
    if (cached.isNotEmpty) {
      _orders.assignAll(
        cached.map(DmDeliveryOrderModel.fromJson).toList(growable: false),
      );
    } else {
      _orders.assignAll(AppMockData.dmOrders);
      await _persist();
    }
    _hydrated = true;
  }

  Future<void> _persist() async {
    await _cache.saveList(
      OfflineCacheKeys.dmOrders,
      _orders.map((e) => e.toJson()).toList(growable: false),
    );
  }

  Future<void> _enqueue(String action, Map<String, dynamic> payload) async {
    await _cache.enqueueSync(role: _role, action: action, payload: payload);
    if (_connectivity.isOnline.value) {
      await _cache.flushSyncQueue();
    }
  }

  DmTimelineEventModel _event(String title, {String? note}) =>
      DmTimelineEventModel(
        id: 'tl-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        at: DateTime.now(),
        note: note,
      );

  Future<List<DmDeliveryOrderModel>> fetchOrders() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    await _ensureHydrated();
    return _orders.toList(growable: false);
  }

  Future<List<DmDeliveryOrderModel>> fetchByStatus(
    DeliveryStatus status,
  ) async {
    final all = await fetchOrders();
    return all.where((item) => item.status == status).toList(growable: false);
  }

  Future<List<DmDeliveryOrderModel>> fetchByStatuses(
    Set<DeliveryStatus> statuses,
  ) async {
    final all = await fetchOrders();
    return all
        .where((item) => statuses.contains(item.status))
        .toList(growable: false);
  }

  Future<DmDeliveryOrderModel?> fetchOrderById(String id) async {
    final all = await fetchOrders();
    for (final order in all) {
      if (order.id == id) return order;
    }
    return null;
  }

  Future<DmDeliveryOrderModel?> markPickedUp(
    String id, {
    required List<DmOrderLineModel> loadedLines,
  }) async {
    await _ensureHydrated();
    final index = _orders.indexWhere((item) => item.id == id);
    if (index < 0) return null;

    final current = _orders[index];
    final byId = {for (final line in loadedLines) line.id: line};
    final lines = current.lines
        .map((line) {
          final next = byId[line.id];
          if (next == null) return line;
          return line.copyWith(loadedQty: next.loadedQty);
        })
        .toList(growable: false);

    final updated = current.copyWith(
      status: DeliveryStatus.pickedUp,
      lines: lines,
      timeline: [...current.timeline, _event('Stock picked up')],
    );
    _orders[index] = updated;
    await _persist();
    await _enqueue('mark_picked_up', {
      'order_id': id,
      'lines': loadedLines.map((e) => e.toJson()).toList(),
    });
    return updated;
  }

  Future<DmDeliveryOrderModel?> startDelivery(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    await _ensureHydrated();
    final index = _orders.indexWhere((item) => item.id == id);
    if (index < 0) return null;

    final current = _orders[index];
    if (current.status != DeliveryStatus.pending &&
        current.status != DeliveryStatus.pickedUp) {
      return current;
    }

    final updated = current.copyWith(
      status: DeliveryStatus.inTransit,
      timeline: [...current.timeline, _event('Out for delivery')],
    );
    _orders[index] = updated;
    await _persist();
    await _enqueue('start_delivery', {'order_id': id});
    return updated;
  }

  Future<DmDeliveryOrderModel?> submitDelivery({
    required String id,
    required List<DmOrderLineModel> deliveredLines,
    required String receiverName,
    String? proofPhotoBase64,
    String? notes,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    await _ensureHydrated();
    final index = _orders.indexWhere((item) => item.id == id);
    if (index < 0) return null;

    final current = _orders[index];
    final byId = {for (final line in deliveredLines) line.id: line};
    final lines = current.lines
        .map((line) {
          final next = byId[line.id];
          if (next == null) return line;
          return line.copyWith(
            deliveredQty: next.deliveredQty,
            rejectedQty: next.rejectedQty,
          );
        })
        .toList(growable: false);

    final hasReturn = lines.any((line) => line.returnableQty > 0);

    final updated = current.copyWith(
      status: hasReturn && lines.every((l) => l.deliveredQty <= 0)
          ? DeliveryStatus.returned
          : DeliveryStatus.delivered,
      lines: lines,
      receiverName: receiverName.trim(),
      proofPhotoBase64: proofPhotoBase64,
      deliveryNotes: notes,
      deliveredAt: DateTime.now(),
      timeline: [
        ...current.timeline,
        _event('Delivered', note: 'Received by ${receiverName.trim()}'),
      ],
    );
    _orders[index] = updated;
    await _persist();
    await _enqueue('submit_delivery', {
      'order_id': id,
      'receiver_name': receiverName.trim(),
      'notes': notes,
      'has_proof_photo':
          proofPhotoBase64 != null && proofPhotoBase64.isNotEmpty,
      'lines': deliveredLines.map((e) => e.toJson()).toList(),
    });
    return updated;
  }

  /// Legacy helper used by older UI paths.
  Future<DmDeliveryOrderModel?> markDelivered(String id) async {
    final order = await fetchOrderById(id);
    if (order == null) return null;
    return submitDelivery(
      id: id,
      deliveredLines: order.lines
          .map(
            (line) => line.copyWith(
              deliveredQty: line.loadedQty > 0
                  ? line.loadedQty
                  : line.orderedQty,
            ),
          )
          .toList(growable: false),
      receiverName: 'Shop keeper',
    );
  }
}
