import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/return/dm_return_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';

class DmReturnService extends GetxService {
  DmReturnService({
    OfflineCacheService? cache,
    ConnectivityService? connectivity,
    this._deliveryService,
  }) : _cache = cache ?? Get.find<OfflineCacheService>(),
       _connectivity = connectivity ?? Get.find<ConnectivityService>();

  final OfflineCacheService _cache;
  final ConnectivityService _connectivity;
  final DmDeliveryService? _deliveryService;
  bool _hydrated = false;
  DmReturnModel? _lastSubmitted;

  static const _role = 'deliveryMan';

  @override
  void onInit() {
    super.onInit();
    // Live API call lands here when return endpoints exist.
    _cache.registerSyncHandler(_role, 'submit_return', (_) async {});
  }

  DmDeliveryService get _deliveries =>
      _deliveryService ?? Get.find<DmDeliveryService>();

  Future<void> _ensureHydrated() async {
    if (_hydrated) return;
    final cached = await _cache.readMap(OfflineCacheKeys.dmReturn);
    if (cached != null) {
      _lastSubmitted = DmReturnModel.fromJson(cached);
    }
    _hydrated = true;
  }

  Future<DmReturnModel> fetchReturnTemplate() async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    await _ensureHydrated();
    if (_lastSubmitted != null && _lastSubmitted!.submitted) {
      return _lastSubmitted!;
    }
    return buildReturnFromOrders();
  }

  Future<DmReturnModel> buildReturnFromOrders() async {
    final orders = await _deliveries.fetchOrders();
    final byProduct = <String, DmReturnLineModel>{};

    for (final order in orders) {
      if (order.status != DeliveryStatus.delivered &&
          order.status != DeliveryStatus.returned &&
          order.status != DeliveryStatus.inTransit &&
          order.status != DeliveryStatus.pickedUp) {
        continue;
      }
      for (final line in order.lines) {
        final left = line.returnableQty.round();
        if (left <= 0) continue;
        final existing = byProduct[line.productName];
        if (existing == null) {
          byProduct[line.productName] = DmReturnLineModel(
            productId: line.id,
            productName: line.productName,
            quantity: left,
          );
        } else {
          byProduct[line.productName] = existing.copyWith(
            quantity: existing.quantity + left,
          );
        }
      }
    }

    return DmReturnModel(
      id: '',
      deliveryId: 'shift-${DateTime.now().toIso8601String().substring(0, 10)}',
      leftover: byProduct.values.toList(growable: false),
    );
  }

  Future<DmReturnModel> submitReturn(DmReturnModel payload) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    await _ensureHydrated();
    final submitted = payload.copyWith(
      id: 'ret-${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      submitted: true,
    );
    _lastSubmitted = submitted;
    await _cache.saveMap(OfflineCacheKeys.dmReturn, submitted.toJson());
    await _cache.enqueueSync(
      role: _role,
      action: 'submit_return',
      payload: submitted.toJson(),
    );
    if (_connectivity.isOnline.value) {
      await _cache.flushSyncQueue();
    }
    return submitted;
  }
}
