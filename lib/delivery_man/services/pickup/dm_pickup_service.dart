import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/pickup/dm_pickup_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';

class DmPickupService extends GetxService {
  DmPickupService({
    OfflineCacheService? cache,
    ConnectivityService? connectivity,
  }) : _cache = cache ?? Get.find<OfflineCacheService>(),
       _connectivity = connectivity ?? Get.find<ConnectivityService>();

  final OfflineCacheService _cache;
  final ConnectivityService _connectivity;
  final Rxn<DmPickupModel> _session = Rxn<DmPickupModel>();
  bool _hydrated = false;

  static const _role = 'deliveryMan';

  @override
  void onInit() {
    super.onInit();
    // Live API call lands here when pickup endpoints exist.
    _cache.registerSyncHandler(_role, 'confirm_pickup', (_) async {});
  }

  Future<void> _ensureHydrated() async {
    if (_hydrated) return;
    final cached = await _cache.readMap(OfflineCacheKeys.dmPickup);
    if (cached != null) {
      _session.value = DmPickupModel.fromJson(cached);
    } else {
      _session.value = AppMockData.dmPickupSession;
      await _persist();
    }
    _hydrated = true;
  }

  Future<void> _persist() async {
    final current = _session.value;
    if (current == null) return;
    await _cache.saveMap(OfflineCacheKeys.dmPickup, current.toJson());
  }

  Future<DmPickupModel> fetchTodayPickup() async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
    await _ensureHydrated();
    return _session.value!;
  }

  Future<DmPickupModel> confirmPickup({
    required List<DmStockItemModel> loadedItems,
  }) async {
    await _ensureHydrated();
    final current = _session.value!;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final updated = current.copyWith(
      items: loadedItems,
      acknowledgedAt: DateTime.now(),
    );
    _session.value = updated;
    await _persist();
    await _cache.enqueueSync(
      role: _role,
      action: 'confirm_pickup',
      payload: {
        'pickup_id': updated.id,
        'items': loadedItems.map((e) => e.toJson()).toList(),
      },
    );
    if (_connectivity.isOnline.value) {
      await _cache.flushSyncQueue();
    }
    return updated;
  }
}
