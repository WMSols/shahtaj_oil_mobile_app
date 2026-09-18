import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_product_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_snapshot_model.dart';

/// Free van transfers: snapshot, products catalog, WH→van load, van→WH return.
class DmVanService extends GetxService {
  DmVanService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  final Rxn<DmVanSnapshotModel> snapshot = Rxn<DmVanSnapshotModel>();
  final RxList<DmVanProductModel> products = <DmVanProductModel>[].obs;

  DmVanSnapshotModel? get current => snapshot.value;

  Future<DmVanSnapshotModel> fetchSnapshot({bool forceNetwork = false}) async {
    final result = await _cache.readThrough(
      key: OfflineCacheKeys.dmVanSnapshot,
      fetch: () => _api.postData(ApiEndpoints.dmVanSnapshot),
      parse: (json) =>
          DmVanSnapshotModel.fromJson(ApiMap.asMap(json['van']) ?? json),
      allowStaleFallback: true,
      cacheFirst: _cache.cacheFirstFor(
        allowStaleFallback: true,
        forceNetwork: forceNetwork,
      ),
    );
    snapshot.value = result;
    return result;
  }

  Future<List<DmVanProductModel>> fetchProducts() async {
    final data = await _api.postData(ApiEndpoints.dmVanProducts);
    final list = ApiMap.listOf(
      data,
      'products',
    ).map(DmVanProductModel.fromJson).toList(growable: false);
    products.assignAll(list);
    return list;
  }

  Future<DmVanSnapshotModel> loadToVan({
    required List<({int productId, double qty})> lines,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmVanLoad,
      data: {
        'lines': [
          for (final line in lines)
            if (line.qty > 0) {'product_id': line.productId, 'qty': line.qty},
        ],
      },
    );
    return _applyVan(data);
  }

  Future<DmVanSnapshotModel> returnToWarehouse({
    required List<({int productId, double qty})> lines,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmVanReturn,
      data: {
        'lines': [
          for (final line in lines)
            if (line.qty > 0) {'product_id': line.productId, 'qty': line.qty},
        ],
      },
    );
    return _applyVan(data);
  }

  /// Applies a van payload from load/return/free-deliver responses.
  Future<DmVanSnapshotModel> applyFromPayload(Map<String, dynamic> json) async {
    final next = DmVanSnapshotModel.fromJson(json);
    snapshot.value = next;
    await _cache.saveMap(OfflineCacheKeys.dmVanSnapshot, next.toJson());
    return next;
  }

  Future<DmVanSnapshotModel> _applyVan(Map<String, dynamic> data) async {
    return applyFromPayload(ApiMap.asMap(data['van']) ?? data);
  }
}
