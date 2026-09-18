import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_collect_result.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_collection_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_model.dart';

/// Live recovery + wallet APIs (`recovery/*`, `wallet/*`).
class DmRecoveryService extends GetxService {
  DmRecoveryService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  final Rxn<DmWalletModel> wallet = Rxn<DmWalletModel>();
  final Rxn<DmRecoveryShopModel> activeShop = Rxn<DmRecoveryShopModel>();
  final Rxn<DmWalletCollectionsPage> collectionsPage =
      Rxn<DmWalletCollectionsPage>();

  static String shopCacheKey(String shopId) =>
      '${OfflineCacheKeys.dmRecoveryShopPrefix}$shopId';

  Future<DmRecoveryShopModel> fetchShop(
    int shopId, {
    bool forceNetwork = false,
  }) async {
    final result = await _cache.readThrough(
      key: shopCacheKey('$shopId'),
      fetch: () =>
          _api.postData(ApiEndpoints.dmRecoveryShop, data: {'shop_id': shopId}),
      parse: DmRecoveryShopModel.fromJson,
      allowStaleFallback: true,
      cacheFirst: _cache.cacheFirstFor(
        allowStaleFallback: true,
        forceNetwork: forceNetwork,
      ),
    );
    activeShop.value = result;
    return result;
  }

  Future<DmRecoveryCollectResult> collect({
    required int shopId,
    required List<({int invoiceId, double amount})> allocations,
    required PaymentMethod paymentMethod,
    String? chequeNumber,
    String? chequeImageBase64,
    String? notes,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.dmRecoveryCollect,
      data: {
        'shop_id': shopId,
        'payment_method': paymentMethod.name,
        'allocations': [
          for (final row in allocations)
            if (row.amount > 0)
              {'invoice_id': row.invoiceId, 'amount': row.amount},
        ],
        if (paymentMethod == PaymentMethod.cheque) ...{
          if (chequeNumber != null && chequeNumber.trim().isNotEmpty)
            'cheque_number': chequeNumber.trim(),
          if (chequeImageBase64 != null && chequeImageBase64.isNotEmpty)
            'cheque_image': chequeImageBase64,
        },
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );
    final result = DmRecoveryCollectResult.fromJson(data);
    if (result.shop != null) {
      activeShop.value = result.shop;
      await _cache.saveMap(shopCacheKey(result.shopId), result.shop!.toJson());
    }
    if (result.wallet != null) {
      wallet.value = result.wallet;
      await _cache.saveMap(OfflineCacheKeys.dmWallet, result.wallet!.toJson());
    }
    return result;
  }

  Future<DmWalletModel> fetchWallet({bool forceNetwork = false}) async {
    final result = await _cache.readThrough(
      key: OfflineCacheKeys.dmWallet,
      fetch: () => _api.postData(ApiEndpoints.dmWalletGet),
      parse: DmWalletModel.fromJson,
      allowStaleFallback: true,
      cacheFirst: _cache.cacheFirstFor(
        allowStaleFallback: true,
        forceNetwork: forceNetwork,
      ),
    );
    wallet.value = result;
    return result;
  }

  Future<DmWalletCollectionsPage> fetchCollections({
    DateTime? dateFrom,
    DateTime? dateTo,
    int limit = 50,
    bool forceNetwork = false,
  }) async {
    final result = await _cache.readThrough(
      key: OfflineCacheKeys.dmWalletCollections,
      fetch: () => _api.postData(
        ApiEndpoints.dmWalletCollections,
        data: {
          if (dateFrom != null) 'date_from': AppFormatter.apiDate(dateFrom),
          if (dateTo != null) 'date_to': AppFormatter.apiDate(dateTo),
          'limit': limit.clamp(1, 200),
        },
      ),
      parse: DmWalletCollectionsPage.fromJson,
      allowStaleFallback: true,
      cacheFirst: _cache.cacheFirstFor(
        allowStaleFallback: true,
        forceNetwork: forceNetwork,
      ),
    );
    collectionsPage.value = result;
    if (wallet.value != null) {
      wallet.value = DmWalletModel(
        deliveryManId: wallet.value!.deliveryManId,
        currency: wallet.value!.currency,
        balance: result.walletBalance > 0
            ? result.walletBalance
            : wallet.value!.balance,
        collectedToday: wallet.value!.collectedToday,
        collectedTotal: wallet.value!.collectedTotal,
        settledTotal: wallet.value!.settledTotal,
        asOf: wallet.value!.asOf,
      );
    }
    return result;
  }
}
