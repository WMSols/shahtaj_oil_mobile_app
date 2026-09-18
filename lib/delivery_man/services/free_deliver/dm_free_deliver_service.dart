import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/shops/dm_free_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_snapshot_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';

/// Off-plan van stock delivery: shop search + GPS free deliver.
class DmFreeDeliverService extends GetxService {
  DmFreeDeliverService(this._api, this._vanService);

  final ApiClient _api;
  final DmVanService _vanService;

  Future<List<DmFreeShopModel>> searchShops({
    String? query,
    int limit = 30,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmShopsSearch,
      data: {
        if (query != null && query.trim().isNotEmpty) 'query': query.trim(),
        'limit': limit,
      },
    );
    return ApiMap.listOf(
      data,
      'shops',
    ).map(DmFreeShopModel.fromJson).toList(growable: false);
  }

  Future<DmVanSnapshotModel> deliverFree({
    required int shopId,
    required double latitude,
    required double longitude,
    required List<({int productId, double qty})> lines,
    required String receiverName,
    required String deliveryProofImageBase64,
    String? notes,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmDeliverFree,
      data: {
        'shop_id': shopId,
        'latitude': latitude,
        'longitude': longitude,
        'receiver_name': receiverName.trim(),
        'delivery_proof_image': deliveryProofImageBase64,
        'lines': [
          for (final line in lines)
            if (line.qty > 0) {'product_id': line.productId, 'qty': line.qty},
        ],
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );
    return _vanService.applyFromPayload(ApiMap.asMap(data['van']) ?? data);
  }
}
