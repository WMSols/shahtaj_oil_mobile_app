import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/walk_in_deliver/dm_walk_in_deliver_result.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/walk_in_deliver/dm_walk_in_registry.dart';

/// Walk-in cash-and-carry from surplus van stock (`qty_free` on API).
class DmWalkInDeliverService extends GetxService {
  DmWalkInDeliverService(
    this._api,
    this._vanService, {
    OfflineCacheService? cache,
  }) : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final DmVanService _vanService;
  final OfflineCacheService _cache;

  Future<DmWalkInDeliverResult> deliverWalkIn({
    required String customerName,
    String? phone,
    required double latitude,
    required double longitude,
    required String receiverName,
    required String deliveryProofImageBase64,
    required List<({int productId, double qty})> lines,
    PaymentMethod paymentMethod = PaymentMethod.cash,
    String? chequeNumber,
    String? chequeImageBase64,
    String? notes,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmDeliverWalkIn,
      data: {
        'customer_name': customerName.trim(),
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
        'latitude': latitude,
        'longitude': longitude,
        'receiver_name': receiverName.trim(),
        'delivery_proof_image': deliveryProofImageBase64,
        'payment_method': paymentMethod.name,
        if (paymentMethod == PaymentMethod.cheque) ...{
          if (chequeNumber != null && chequeNumber.trim().isNotEmpty)
            'cheque_number': chequeNumber.trim(),
          if (chequeImageBase64 != null && chequeImageBase64.isNotEmpty)
            'cheque_image': chequeImageBase64,
        },
        'lines': [
          for (final line in lines)
            if (line.qty > 0) {'product_id': line.productId, 'qty': line.qty},
        ],
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );

    final result = DmWalkInDeliverResult.fromJson(ApiMap.asMap(data) ?? data);

    if (Get.isRegistered<DmWalkInRegistry>()) {
      await Get.find<DmWalkInRegistry>().remember(
        jobId: result.deliveryId,
        paymentId: result.paymentId,
        shopId: result.partnerId?.toString(),
      );
    }

    if (result.van != null) {
      await _vanService.applyFromPayload(result.van!.toJson());
    } else {
      final vanJson = ApiMap.asMap(data['van']);
      if (vanJson != null) {
        await _vanService.applyFromPayload(vanJson);
      }
    }

    if (result.wallet != null) {
      if (Get.isRegistered<DmRecoveryService>()) {
        Get.find<DmRecoveryService>().wallet.value = result.wallet;
      }
      await _cache.saveMap(OfflineCacheKeys.dmWallet, result.wallet!.toJson());
    }

    if (Get.isRegistered<DmPlanService>()) {
      await Get.find<DmPlanService>().fetchToday(forceNetwork: true);
    }

    if (Get.isRegistered<DmRecoveryService>()) {
      try {
        await Get.find<DmRecoveryService>().fetchCollections(
          forceNetwork: true,
        );
      } catch (_) {}
    }

    return result;
  }
}
